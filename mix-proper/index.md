# Property-based testing in Elixir using PropEr

While reading [Fred Hébert]'s [PropEr testing], on property-based testing in Erlang, I set out write [PropEr] tests in Elixir, and run them with a Mix task.<sup>[^1]</sup>

![mix_proper running property-based tests in an Elixir project](https://jeffkreeftmeijer.com/mix-proper/mix_proper.png)

## Writing PropEr tests in Elixir

To explain writing PropEr tests (named "properties") in Elixir, let's take [an example from PropEr testing]. A property of a function named `biggest/1` is that the returned value is equal to the biggest value in the passed list.

``` erlang
# test/prop_biggest.erl
-module(prop_biggest).
-include_lib("proper/include/proper.hrl").

prop_biggest() ->
    ?FORALL(List, non_empty(list(integer())),              # ➊
        begin
            biggest(List) =:= lists:last(lists:sort(List)) # ➋
        end).
```

1. `?FORALL` is a macro around `proper:forall/2`.<sup>[^2]</sup> It takes a variable name, a generator, and a property. In this case, the generator returns a random, non-empty list of integers and puts it in the `List` variable for every run.

2. The property itself is a function that uses the random variable to assert the result from `biggest/1` matches the biggest value in the list.

Converting it to Elixir, this property looks a bit different.

``` elixir
# test/biggest_prop.exs
defmodule BiggestProp do
  # ➊
  import :proper
  import :proper_types

  def prop_biggest do
    forall(non_empty(list(integer())), fn(list) ->    # ➋
      biggest(list) == list |> Enum.sort |> List.last # ➌
    end)
  end

  # ...
end
```

1. The `:proper` and `:proper_types` modules are imported manually instead of including the `proper.hrl` header file, which is a mostly [a list of imports] itself.
2. Elixir [doesn't support Erlang's macros], so `:proper.forall/2` is called directly.
3. Although Erlang's `lists` module would work, `Enum.sort/1` and `List.last/1` are used as trusted functions to test the implementation.

With a [working implementation], and [:proper] included in the project's dependencies, the property can be run in IEx by requiring the test file manually and running the property through `:proper.quickcheck/1`.

```
$ iex -S mix
iex(1)> Kernel.ParallelRequire.files(["test/biggest_prop.exs"])
[BiggestProp]
iex(2)> :proper.quickcheck(BiggestProp.prop_biggest())
....................................................................................................
OK: Passed 100 test(s).
true
```

## rebar3_proper and mix_proper

Although that worked, it would be nice to have a command to quickly run all tests in a Mix project. For Erlang, there's a library named [rebar3_proper] that does just that by adding the `rebar3 proper` command.

```
$ rebar3 proper
===> Testing prop_biggest:prop_biggest()
....................................................................................................
OK: Passed 100 test(s).
===>
1/1 properties passed
```

rebar3\_proper runs tests by finding functions and modules with names prefixed with "prop_" and running them through `proper:quickcheck/1`. That would work in Elixir by adding a Mix task that uses the same approach.<sup>[^3]</sup>

``` elixir
defmodule Mix.Tasks.Proper do
  use Mix.Task

  def run([]) do
    "test/**/*_prop.exs"
    |> Path.wildcard
    |> Kernel.ParallelRequire.files # => [BiggestProp]
    # ...
  end

  # ...
end
```

Using "test/\*\*/\*_prop.exs" as a wildcard pattern, the paths for all property-based testing files in the test directory are found. Being .exs files, they are not compiled, so they need to be required manually when they're needed. [Mix's own test task uses `Kernel.ParallelRequire.files/1-2`], which takes a list of filenames, includes the modules in the files and returns the names of the newly included modules.

``` elixir
defmodule Mix.Tasks.Proper do
  use Mix.Task

  def run([]) do
    "test/**/*_prop.exs"
    |> Path.wildcard
    |> Kernel.ParallelRequire.files
    |> Enum.each(fn(module) ->
      module.__info__(:functions)
      |> Enum.filter(&property?/1)
      |> Enum.map(fn({name, 0}) ->
        :proper.quickcheck(apply(module, name, []))
      end)
    end)
  end

  # ...
end
```

Using the list of included modules, their property functions are found using the `__info__/1` function. Functions without the proper name or an arity other than 0 get [filtered out]. The remaining functions in the list are called using `:erlang.apply/3`, and their results are passed to `:proper.quickcheck/1`, which runs the tests.

```
$ mix proper
....................................................................................................
OK: Passed 100 test(s).
```

That's it. The proper Mix task finds property-based test files, includes them, and runs each of the properties in those files through PropEr. The code above is the basis of [mix_proper], which can be used in your Elixir project by [adding it as a dependency].<sup>[^4]</sup>

[Fred Hébert]: http://ferd.ca
[PropEr testing]: http://propertesting.com
[PropEr]: http://proper.softlab.ntua.gr
[an example from PropEr testing]: http://propertesting.com/book_stateless_properties.html#_writing_properties
[a list of imports]: https://github.com/manopapad/proper/blob/master/include/proper.hrl
[doesn't support Erlang's macros]: https://groups.google.com/forum/#!topic/elixir-lang-talk/VbGTz7rKebM
[working implementation]: https://github.com/jeffkreeftmeijer/mix_proper_example/blob/a09d6ac1bc800ae3f77a105c76f8db44d9b8d5ce/test/biggest_prop.exs#L19-L27
[:proper]: https://hex.pm/packages/proper
[rebar3_proper]: https://github.com/ferd/rebar3_proper
[Mix's own test task uses `Kernel.ParallelRequire.files/1-2`]: https://github.com/elixir-lang/elixir/blob/df7e0ca55cd03e3d46f426c7cd02fd25dcf2df87/lib/mix/lib/mix/compilers/test.ex#L50
[filtered out]: https://github.com/jeffkreeftmeijer/mix_proper/blob/fda1e4b19c6aabdf856b7d4948102409e0a5c9fc/lib/mix/tasks/proper.ex#L30-L35
[mix_proper]: https://github.com/jeffkreeftmeijer/mix_proper
[adding it as a dependency]: https://github.com/jeffkreeftmeijer/mix_proper_example/blob/master/mix.exs#L24
[StreamData]: https://github.com/whatyouhide/stream_data
[Quixir]: https://github.com/pragdave/quixir
[ExCheck]: https://github.com/parroty/excheck
[triq]: https://github.com/krestenkrab/triq
[PropCheck]: https://github.com/alfert/propcheck
[issue]: https://github.com/jeffkreeftmeijer/mix_proper/issues

[^1]: Besides running PropEr, there are more ways to do property-based testing with Elixir.

    [StreamData] and [Quixir] are both pure-Elixir libraries. StreamData is a candidate to be included in Elixir itself. If you want to get into property-based testing, one of these is probably your best bet. [ExCheck] is a wrapper around [triq], while [PropCheck] wraps PropEr. All of them use ExUnit to run their tests.

    However, I was curious to see if I could get it to work without having to wrap a lot of PropEr's functions by just importing its modules in Elixir and running its functions directly while learning some things about Erlang along the way.

[^2]:  Since `?FORALL` is a macro around `proper:forall/2`, this example can also be written without it, revealing the function call underneath.

    ```
    # test/prop_biggest.erl
    -module(prop_biggest).
    -include_lib("proper/include/proper.hrl").

    prop_biggest() ->
        proper:forall(non_empty(list(integer())), fun(List) ->
            biggest(List) =:= lists:last(lists:sort(List))
        end).
    ```

[^3]: Instead of *prefixing* the names for modules with property-based tests with ""Prop" (like "PropBiggest"), I chose to add it as a suffix. By adding "Prop" to the end, the module names are in line with ExUnit's, which suffixes its test case module names with "Test" (like "BiggestTest", for example).

    The names for the properties themselves *are* prefixed with "prop_", like in rebar3_proper, for now. I could do away with function name matching and use a macro to use for defining tests (like StreamData does, for example), but I like not having to import anything but PropEr's modules.

[^4]: mix_proper is still a proof of concept. Although running tests works, you could run into some problems with PropEr's generators in Elixir. If you run into one, please don't hesitate to open an [issue].
