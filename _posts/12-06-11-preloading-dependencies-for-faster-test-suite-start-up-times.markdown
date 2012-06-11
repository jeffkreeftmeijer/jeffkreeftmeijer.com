---
layout: post
title: Preloading dependencies for faster test suite start-up times
excerpt: To speed up our start-up times between test runs, we'll write a really simple dependency preloader in about twenty lines of Ruby.
published: true
---

Tools like [Spin](https://github.com/jstorimer/spin) and [Spork](https://github.com/sporkrb/spork) help you speed up your test runs by preloading your application's dependencies and running your test suite without reloading the whole stack each time. That sounds like magic, but it's actually quite simple to build a tool that can do something like that. In this article, we'll write a dependency preloader in about twenty lines of Ruby. Ready? Let's go!

To keep things understandable, We'll start out with a simple file named `test.rb`, pretending to be a test file by printing out a hundred dots:

{% highlight ruby %}
require File.expand_path 'slow'

100.times do
  sleep rand * 0.01
  print '.'
end
{% endhighlight %}

It requires a file named `slow.rb`, which will simulate your suite's startup time:

{% highlight ruby %}
sleep 2
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/2909445/5cabc0559d3a3d9aad90721306bac4aa8f4cfa9b">https://gist.github.com/2909445/5cabc0…</a></span>

As you might have guessed, when you run `ruby test.rb`, it'll take two seconds before anything happens. That probably looks a lot like your Rails application's test suite, right? Now, waiting for two seconds is no real problem unless you're running your suite multiple times. If you run `ruby test.rb` three times now, you'll notice what I mean. 

### Forking

In this case, `slow.rb` is a dependency that doesn't change too often, like Rails or some other library your application depends on. That means it's safe to preload it and run the test suite with it a couple of times, instead of reloading it for each run. We can do that by requiring it once and forking the process every time we run our test suite. A simple example of that could look like this, which will run `test.rb` three times without reloading `slow.rb`:

{% highlight ruby %}
require File.expand_path 'slow'

3.times do 
  fork do 
    require File.expand_path 'test'
  end

  Process.wait
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/2909445/ec2f2245bb8b8ee411723f02eccaa0e9c1e65f30">https://gist.github.com/2909445/ec2f22…</a></span>

After preloading `slow.rb` on the first line, we'll go into a loop which creates a subprocess using `fork`. We'll require `test.rb` in this subprocess and finally, we'll call `Process.wait` in the main process, which will halt to wait for the subprocess to exit. Because `slow.rb` is already required in the main process before forking off, it won't be loaded again by `test.rb` in the forked subprocesses.

### Server

On to the real thing. To make this usable as an actual tool, we need to turn it into a server that can receive messages and run tests when prompted to. To be able to talk between two Ruby processes, we'll use [DRb](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html). Let's create a file named `server.rb`:

{% highlight ruby %}
require 'drb'
ARGV.each { |file| require File.expand_path file }
Rails.env = 'test' if defined? Rails 

class Runner
  def run(files)
    fork do
      files.each { |file| require File.expand_path file }
    end
    Process.wait
  end
end

DRb.start_service 'druby://:4321', Runner.new
DRb.thread.join
{% endhighlight %}

As you can see, `Runner#run` looks a lot like what we've done before. The big difference is that we put it in a class named `Runner` and started a DRb service with a reference to an instance of it. This allows a client connected to the service to directly call methods on the `Runner` instance. Let's create another file, named `client.rb`:

{% highlight ruby %}
require 'drb'

runner = DRbObject.new nil, 'druby://:4321'
runner.run(ARGV)
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/2909445/185119a265744aea8d69a1df2fc60fdd7a97164b">https://gist.github.com/2909445/185119a265744aea8…</a></span>


The only thing the client does is create a new `DRbObject` --which returns the instance of `Runner` we initialized in `server.rb`-- and call the `run` method on it.

To try it out, start your server and tell it to preload `slow.rb`:

{% highlight console %}
$ ruby server.rb slow
{% endhighlight %}

And run our test file using the client in another terminal window:

{% highlight console %}
$ ruby client.rb test
{% endhighlight %}

As you'll see, your tests will start almost instantly.

Note: if you want to use your new preloader in a Rails application, you'll probably want to preload `config/application`, since that's the file that starts your application and tells Bundler to require your dependencies.

See how easy it is to preload dependencies instead of loading them before each test run? Of course, this could use a lot of work, but this was just an attempt to show you a really simple way to ease the pain of your application's startup time when running your tests. If you're looking for something more polished, check out [Spin](https://github.com/jstorimer/spin), by [@jstorimer](http://twitter.com/jstorimer "Jesse Storimer").
