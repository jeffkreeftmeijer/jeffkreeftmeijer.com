---
layout: post
title: "Spec helpers, Bundler.setup and faster Rails test suites"
excerpt: Loading dependencies in your Rails models, controllers, and initializers instead of letting Bundler pre-require everything all the time.
published: true
---

The `spec_helper.rb` file rspec-rails generates is convenient, as it sets up everything you need to get your tests running. In your actual test, all you have to do is `require "spec_helper"` and off you go. After waiting for a while.

![Bundler.setup instead of Bundler.require](http://jeffkreeftmeijer.com/images/bundler_setup.png)

Your `spec_helper` is probably slowing your tests down quite a bit while it doesn't have to. To get an idea of how long it's taking, let's just time it (if you're following along, I'd love to know how long yours takes to load in the comments):

{% highlight console %}
$ time ruby spec/spec_helper.rb
ruby spec/spec_helper.rb  16.38s user 1.83s system 92% cpu 19.691 total
{% endhighlight %}

For [Codebrawl](http://codebrawl.com), that's almost twenty seconds. Not to run the suite, but just to require everything needed. Wow. Also remember that this spec helper is being required even when running model specs.

Let's try to speed up a fairly simple spec for the `User` model. The first thing I do is rip out the `require "spec_helper"` line and run the spec. That ends me up with a couple of failures due to the model not being loaded and some missing requirements, so I add them to the top of my spec file:

{% highlight ruby %}
require 'mongoid'
require 'gravtastic'
require File.expand_path('app/models/user')
require 'shoulda-matchers'
{% endhighlight %}

There. The spec's running again and not requiring the spec helper gave me a six second speed boost, cutting off about 30% of my setup time. You might argue that that's still too long, but let's keep that for another blogpost.

### Taking it one step further

There's a line like this in the spec helper rspec-rails generates:

{% highlight ruby %}
require File.expand_path("../../config/environment", __FILE__)
{% endhighlight %}

That line loads up the Rails environment file which, in turn, will require `config/application.rb`. In there, you can find a line like one of these:

{% highlight ruby %}
Bundler.require *Rails.groups(:assets => %w(development test))
# or
Bundler.require(:default, :assets, Rails.env)
{% endhighlight %}

That line takes care of requiring the gems you added to your `:default` and `:test` groups in your Gemfile (in test mode) so you don't have to require anything in your models, for instance.

By not loading up a spec helper, not loading Rails and not running `Bundler.require`, like we just did in our spec, we need to take care of loading gems ourselves. In the example above, I just required the gems I needed in the `User` model spec. That's probably not the best place to put them, since the test should not handle the model's requirements. The model should require the libraries it needs itself, right?

### Bundler.setup instead of Bundler.require

If we change the `Bundler.require` call to a `Bundler.setup` one, Bundler won't require any gems in `config/application.rb` and will leave that all up to you:

{% highlight ruby %}
Bundler.setup *Rails.groups(:assets => %w(development test))
# or
Bundler.setup(:default, :assets, Rails.env)
{% endhighlight %}

Now, run your tests. It might be a good idea to use [RSpec's fail fast](http://jeffkreeftmeijer.com/2010/making-rspec-stop-operation-immediately-after-failing/) option here, because stuff is going to break. Simply add a `require` wherever needed to get your tests running properly again. If you get stuck, just take a look at [my changes in Codebrawl](https://github.com/codebrawl/codebrawl/commit/9df324809cc6e39495af9c78407a6fefed02b7e0).

After doing that, you can remove the model's requirements from your `User` spec file and only leave the spec's requirements:

{% highlight ruby %}
require File.expand_path('app/models/user')
require 'shoulda-matchers'
{% endhighlight %}

From now on, your application's parts handle their requirements themselves instead of relying on Bundler to have them preloaded.  This will allow you to load up one of your models without having to worry about its requirements. So, if your model needs Mongoid, it'll require it itself.

Have any comments, questions or great ideas? Did this approach work for you? Or not? Be sure to let me know in the comments!