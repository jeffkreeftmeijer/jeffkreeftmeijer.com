---
layout: post
title: Method chaining and lazy evaluation in Ruby
excerpt: "To figure out how method chaining and lazy evaluation work, we’ll write a library that can chain method calls to build up a MongoDB query."
published: true
---

Method chaining has been all the rage lately and every database wrapper or aything else that's uses queries seems to be doing it. But, how does it work? To figure that out, we'll write a library that can chain method calls to build up a MongoDB query in this article. Let's get started!

Oh, and don't worry if you haven't used MongoDB before, I'm just using it as an example to query on. If you're using this guide to build a querying library for something else, the MongoDB part should be easy to swap out.

Let's say we're working with a user collection and we want to be able to query it somewhat like this:

{% highlight ruby %}
User.where(:name => 'Jeff').limit(5)
{% endhighlight %}

We'll create a `Criteria` class to build queries. As you might have guessed, it needs two instance methods named `where` and `limit`.

When calling one of these methods, all our object needs to do is remember the criteria that were passed, so we'll need to set up an instance variable -- named `@criteria` -- to store them in.

Our `where` method is used to specify conditions and we want it to return an empty array when none have been specified yet, so we'll add an empty array to our criteria hash by default:

{% highlight ruby %}
class Criteria

  def criteria
    @criteria ||= {:conditions => {}}
  end

end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1397738/946ce04625042250697601fd30f269a495a4b4dc">https://gist.github.com/1397738/946ce0…</a></span>

Now we're able to remember conditions, we need a way to set them. We'll create a `where` method that adds its arguments to the conditions array:

{% highlight ruby %}
class Criteria

  def criteria
    @criteria ||= {:conditions => {}}
  end

  def where(args)
    criteria[:conditions].merge!(args)
  end

end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1397738/dacc040f5aeb35a90f5963d3920464fe28642806">https://gist.github.com/1397738/dacc04…</a></span>

Great! Let's give it a try:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'criteria'
 => true
ruby-1.9.3-p0 :002 > c = Criteria.new
 => #<Criteria:0x007ff9db8bf1f0>
ruby-1.9.3-p0 :003 > c.where(:name => 'Jeff')
 => {:name=>"Jeff"}
ruby-1.9.3-p0 :004 > c
 => #<Criteria:0x007ff9db8bf1f0 @criteria={:conditions=>{:name=>"Jeff"}}>
{% endhighlight %}

As you can see, our `Criteria` object successfully stores our condition in the `@criteria` variable. Let's try to chain another `where` call:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'criteria'
 => true
ruby-1.9.3-p0 :002 > c = Criteria.new
 => #<Criteria:0x007fbf5296d098>
ruby-1.9.3-p0 :003 > c.where(:name => 'Jeff').where(:login => 'jkreeftmeijer')
NoMethodError: undefined method `where' for {:name=>"Jeff"}:Hash
    from (irb):3
    from /Users/jeff/.rvm/rubies/ruby-1.9.3-p0/bin/irb:16:in `<main>'
{% endhighlight %}

Hm. That didn't work, because `where` returns a hash and `Hash` doesn't have a `where` method. We need to make sure the `where` method returns the `Criteria` object. Let's update the `where` method so it returns `self` instead of the conditions variable:

{% highlight ruby %}
class Criteria

  def criteria
    @criteria ||= {:conditions => {}}
  end

  def where(args)
    criteria[:conditions].merge!(args)
    self
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/c5d22217f3856eb5e9e336a27c82874f3801031a">https://gist.github.com/1397738/c5d222…</a></span>

Okay, let's try it again:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'criteria'
 => true
ruby-1.9.3-p0 :002 > c = Criteria.new
 => #<Criteria:0x007fe91117c738>
ruby-1.9.3-p0 :003 > c.where(:name => 'Jeff').where(:login => 'jkreeftmeijer')
 => #<Criteria:0x007fe91117c738 @criteria={:conditions=>{:name=>"Jeff", :login=>"jkreeftmeijer"}}>
{% endhighlight %}

Ha! Now we can chain as many conditions as we want. Let's go ahead and implement that `limit` method right away, so we can limit our query's results.

Of course, we only need one limit, as multiple limits wouldn't make sense. This means we don't need an array, we can just set `criteria[:limit]` instead of merging hashes, like we did with the conditions before:

{% highlight ruby %}
class Criteria

  def criteria
    @criteria ||= {:conditions => {}}
  end

  def where(args)
    criteria[:conditions].merge!(args)
    self
  end

  def limit(limit)
    criteria[:limit] = limit
    self
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/d289697a3a85deb9cc3710ddac181bf2e97d8c3b">https://gist.github.com/1397738/d28969…</a></span>

Now we can chain conditions and even throw in a limit:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'criteria'
 => true
ruby-1.9.3-p0 :002 > c = Criteria.new
 => #<Criteria:0x007fdb1b0ca528>
ruby-1.9.3-p0 :003 > c.where(:name => 'Jeff').limit(5)
 => #<Criteria:0x007fdb1b0ca528 @criteria={:conditions=>{:name=>"Jeff"}, :limit=>5}>
{% endhighlight %}

### The model

There. We can collect query criteria now, but we'll need a model to actually query on. For this example, let's create a model named `User`.

Since we're building a library that can query a MongoDB database, I've installed the [mongo-ruby-driver](https://github.com/mongodb/mongo-ruby-driver) and added a `collection` method to the `User` model:

{% highlight ruby %}
require 'mongo'

class User

  def self.collection
    @collection ||= Mongo::Connection.new['criteria']['users']
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/2b9bd004d7592e51bb698c2f7449771e711c0e35">https://gist.github.com/1397738/2b9bd0…</a></span>

The `collection` method connects to the "criteria" database, looks up the "users" collection and returns an instance of `Mongo::Collection`, which we'll use to query on later.

Remember when I said I wanted to be able to do something like `User.where(:name => 'Jeff').limit(5)`? Well, right now our model doesn't implement `where` or `limit`, since we put them in the `Criteria` class. Let's fix that by creating two methods on `User` that delegate to `Criteria`.

{% highlight ruby %}
require 'mongo'
require File.expand_path 'criteria'

class User

  def self.collection
    @collection ||= Mongo::Connection.new['mongo_chain']['users']
  end

  def self.limit(*args)
    Criteria.new.limit(*args)
  end

  def self.where(*args)
    Criteria.new.where(*args)
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/6035babd3ed2439026c992abc7a12230718a77d1">https://gist.github.com/1397738/6035ba…</a></span>

This allows us to call our criteria methods directly on our model:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'user'
 => true
ruby-1.9.3-p0 :002 > User.where(:name => 'Jeff').limit(5)
 => #<Criteria:0x007fca1c8b0bd0 @criteria={:conditions=>{:name=>"Jeff"}, :limit=>5}>
{% endhighlight %}

Great. Calling criteria on the `User` model returns a `Criteria` object now. But, maybe you already noticed it, the returned object has no idea what to query on. We need to let it know we want to search the users collection. To do that, we need to overwrite the `Criteria`'s `initialize` method:

{% highlight ruby %}
class Criteria

  def initialize(klass)
    @klass = klass
  end

  def criteria
    @criteria ||= {:conditions => {}}
  end

  def where(args)
    criteria[:conditions].merge!(args)
    self
  end

  def limit(limit)
    criteria[:limit] = limit
    self
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/4e2e0b506dfb7ed171368b7b05b9ae560146c582">https://gist.github.com/1397738/4e2e0b…</a></span>

With a slight change to our model -- passing `self` to `Criteria.new` --, we can let the `Criteria` class know what we're looking for:

{% highlight ruby %}
require 'mongo'
require File.expand_path 'criteria'

class User

  def self.collection
    @collection ||= Mongo::Connection.new['criteria']['users']
  end

  def self.limit(*args)
    Criteria.new(self).limit(*args)
  end

  def self.where(*args)
    Criteria.new(self).where(*args)
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/97652e1572efbcc3fe354c45c8905b0fdd975036">https://gist.github.com/1397738/97652e…</a></span>

After a quick test, we can see that the `Criteria` instance successfully remembers our model class:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'user'
 => true
ruby-1.9.3-p0 :002 > User.where(:name => 'Jeff')
 => #<Criteria:0x007ffdd30d4d68 @klass=User, @criteria={:conditions=>{:name=>"Jeff"}}>
{% endhighlight %}

### Getting some results

The last thing we need to do is lazily querying our database and getting some results. To make sure our library doesn't query before collecting all of the criteria, we'll wait until `each` gets called -- to loop over the query's results -- on the `Criteria` instance. Let's see how our library handles that right now:

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'user'
 => true
ruby-1.9.3-p0 :002 > User.where(:name => 'Jeff').each { |u| puts u.inspect }
NoMethodError: undefined method `each' for #<Criteria:0x007fd0540cfea0>
	from (irb):2
	from /Users/jeff/.rvm/rubies/ruby-1.9.3-p0/bin/irb:16:in `<main>'
{% endhighlight %}

Of course, there's no method named `each` on `Criteria`, because we don't have anything to loop over yet. We'll create `Criteria#each`, which will execute the query, giving us an array of results. We use that array's `each` method to pass our block to:

{% highlight ruby %}
class Criteria

  def initialize(klass)
    @klass = klass
  end

  def criteria
    @criteria ||= {:conditions => {}}
  end

  def where(args)
    criteria[:conditions].merge!(args)
    self
  end

  def limit(limit)
    criteria[:limit] = limit
    self
  end

  def each(&block)
    @klass.collection.find(
      criteria[:conditions], {:limit => criteria[:limit]}
    ).each(&block)
  end

end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/1397738/a1a25404469dcce8c1b5de36b0ab48349ca77d84">https://gist.github.com/1397738/a1a254…</a></span>

And now, finally, our query works (don't forget to add some user documents to your database):

{% highlight irb %}
ruby-1.9.3-p0 :001 > require File.expand_path 'user'
 => true
ruby-1.9.3-p0 :002 > User.where(:name => 'Jeff').limit(2).each { |u| puts u.inspect }
{"_id"=>BSON::ObjectId('4ed2603b368ff6d6bc000001'), "name"=>"Jeff"}
{"_id"=>BSON::ObjectId('4ed2603b368ff6d6bc000002'), "name"=>"Jeff"}
 => nil
{% endhighlight %}

### Awesome! Now what?

Now you have a library that can do chained and lazy-evaluated queries on a MongoDB database. Of course, there's a lot of stuff you could still add -- for example, you could mix in [Enumerable](http://www.ruby-doc.org/core-1.9.3/Enumerable.html) and do some metaprogramming magic to remove some of the duplication -- but that's beyond the scope of this article.

If you have any questions, ideas, suggestions or comments, or you just want more articles like this one be sure to let me know in the comments.

