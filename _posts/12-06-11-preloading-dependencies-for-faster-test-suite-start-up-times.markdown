---
layout: post
title: Preloading dependencies for faster test suite start-up times
excerpt: 
published: true
---

Tools like [Spin](https://github.com/jstorimer/spin) and [Spork](https://github.com/sporkrb/spork) help you speed up your test runs by preloading your dependencies and running your tests multiple times without reloading the whole stack for each run. But, how does that work? Well, it's actually quite simple. to build a dependency preloader. In this article, I'll try to take some of the magic away by building a dependency preloader at around 20 lines of code. Ready? Let's go!

To keep things understandable, I'll start out with a simple file named `test.rb`, that pretends to be a running test file:

{% highlight ruby %}
require File.expand_path 'slow'

100.times do
  sleep rand * 0.01
  print '.'
end
{% endhighlight %}

It requires a file named `slow.rb`, which will simulate your suite's startup time, caused by loading dependencies:

{% highlight ruby %}
sleep 2
{% endhighlight %}

When you run `ruby test.rb`, you'll notice it takes two seconds before anything happens. That probably looks a lot like your Rails application's test suite, right? Good. Now, waiting for two seconds is no real problem unless you're running your suite multiple times. If you run `ruby test.rb` three times now, you'll notice what I mean. Let's fix that.

### Forking

In this case, `slow.rb` doesn't change too often, like Rails or some other dependency in your application. That means it's safe to preload it and run the test suite with it a couple of times, instead of reloading it for every run. We can do that by requiring it once and forking the process every time we run our test suite. A simple example of that could look like this, which will run `test.rb` three times without reloading its dependencies:

{% highlight ruby %}
require File.expand_path 'slow'

3.times do 
  fork do 
    require File.expand_path 'test'
  end

  Process.wait
end
{% endhighlight %}


After preloading `slow.rb` on the first line, we'll go into a loop which creates a subprocess using `fork`. In this subprocess, we'll require `test.rb`. Finally, we'll call `Process.wait`, which will halt to wait for the subprocess to exit. 

### Server

On to the real thing. To make this usable as an actual tool, we need to turn it into a server that can receive messages and run tests when prompted to. To be able to talk between two Ruby processes, we'll use DRb. Create a file named `server.rb`:

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

The only thing the client does is create a new `DRbObject` (which will return the instance of `Runner` we initialized in `server.rb`) and call the `run` method on it using whatever's been passed to `ARGV`. 

To try it out, start your server and tell it to preload `slow.rb`:

{% highlight console %}
$ ruby server.rb slow
{% endhighlight %}

And run our test file using the client in another terminal window:

{% highlight console %}
$ ruby client.rb test
{% endhighlight %}

As you'll see, your tests will start almost instantly. If you want to use your new preloader in a Rails application, you'll probably want to preload `config/application`, since that's the file that starts your application and tells Bundler to require your dependencies.

See how easy it is to preload dependencies instead of loading them before every test run? Of course, this could use a lot of work, but this was just an attempt to show you a really simple way to ease the pain of your application's startup time when running your tests. If you're looking for something more polished, check out [Spin](https://github.com/jstorimer/spin), by [@jstorimer](http://twitter.com/jstorimer "Jesse Storimer").
