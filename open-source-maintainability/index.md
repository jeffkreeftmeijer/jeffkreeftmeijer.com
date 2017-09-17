# Keeping open source projects maintainable

If your open source project gains popularity, it will stay included in other
people's projects and workflows for years. It's impossible to predict if you'll
have time to maintain your work in the future, but there are ways to minimize
the amount of maintenance your project requires to remain useful.

## Don't add or merge features you won't use yourself

> It didn't take long to implement support for another database management
> system into your background job library. You spent an evening getting it to
> work, and fifteen minutes here and there in to fix some issues in the weeks
> after releasing it. You don't use that database yourself, but you have some
> users who do, and it doesn't take long to get it set up when somebody reports
> a bug.
>
> After a while, an issue comes up. Everything works for the database you use,
> but it's affecting the one you added later. You don't have a lot of time or
> motivation to fix it and setting up the database takes a while. Ths issue sits
> there for a couple of weeks until somebody else sends a pull request. You
> understand most of the fix, the code looks okay and you're glad the bug is
> solved, so you merge it in.
>
> When another issue comes in months later, you have a bigger problem than
> before. You still don't have a lot of time to work on it, and you have code in
> your project you didn't really understand back when you merged it in. Let
> alone now.

Instead of merging new features or implementing them yourself, allow for easy
extension. Consider separating your project's database layer into an adapter
that's easy to swap out for something else. If somebody needs your library to
run on MongoDB, for example, they can write an adapter themselves.

Don't be afraid to tell contributors to maintain their fork instead of merging
their pull request. If a feature doesn't help your own use case, it doesn't have
to be included in your project. This can be difficult if your users are
requesting a something you don't need, but it'll make your project easier to
maintain in the long run. 

## Drop support for old versions of your dependencies

> You wrote a plugin for your favorite editor that adds some useful
> functionality. It's a couple of lines, but wrapping it in a plugin allows you
> and others to easily install it.
>
> A new version of the editor comes out, which adds some functionality that
> makes your plugin even more useful. You update it to take advantage of that
> new feature and made sure not to break backward compatibility. It has a
> version check that loads the original implementation when running in an older
> version of the editor.
> 
> Since the plugin is just a few lines of code, you barely need to update it.
> After a couple of years, you'd like to change the plugin to add a new feature
> or handle some use case better. When you open the code, you can't find a way
> to get this new feature working for the older versions of the editor.
> 
> You're not sure if your changes will break anything, and you don't have the
> ancient editor version running on your machine. Although your project is quite
> popular, you don't know if anyone is still using the old version of the
> editor.

Whenever you start using a new version of a dependency, consider dropping
support for older versions and bumping your major version number. If your users
are tied to a previous version of your dependency, they should lock to an older
version of your project.  Dropping backward compatibility allows you to remove
conditional code that's difficult to develop on. 

Don't backport new features. Since you have limited resources you want your
users to switch to new versions as quickly as possible, even if that means
they'll have to spend time updating their dependencies. 

## Hand over projects if you can't help anymore

> You maintain an add-on for some kind of test framework, that’s specifically
> suited for a problem you have. Since others have the same problem, your
> project is used by hundreds of people. You haven’t implemented anything you
> don’t use yourself, and you quickly drop support for old versions of the test
> framework.
>
> After a while, you start using another test framework on a daily basis. Maybe
> because a new project at your job uses it, or your new situation doesn’t have
> that problem your add-on fixed. You stop using your add-on.
>
> Your project still provides value for its users, but you don’t have time to
> reproduce issues you haven’t run into yourself. There’s a handful of people
> that are excited about your project, so you usually receive a pull request
> when somethin breaks. 
>
> After merging pull requests for a while, the code starts to lack structure
> because there's nobody actively maintaining the project. The code becomes
> increasingly difficult to understand, and it's becoming difficult to even
> press the merge button without breaking the build.

If you stop using your own project, you're not fit to maintain it anymore. You
don't have to do all the work, but you need to be among the first to know when
something breaks. If you don't, you're hurting the project more than you're
helping.

Hand the project over to somebody that actively uses your project and knows the
code. If you can't, open an issue in your tracker to announce you're looking for
a new maintainer. Explain that you can't help anymore and mention that you won't
be answering issues or reviewing pull requests.
