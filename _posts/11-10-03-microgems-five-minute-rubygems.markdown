---
layout: post
title: "MicroGems: five minute RubyGems"
excerpt: Creating RubyGems out of libraries you want to use in multiple projects, without the open source.
published: true
---

<p class="small">
<strong>Note:</strong> This is just something I've been playing around with. I'm not saying you should do this and I'm not implying this is better than what you're doing right now. I'm just sharing some experiences from a quick experiment.
</p>

For [Codebrawl](http://codebrawl.com), I created a library that could take a method from a model -- like `calculate_score` for example -- and give it a corresponding bang method -- `calculate_score!` in this case -- that saves the results using a simple `update_attribute` call. In your model, I can just do this:

{% highlight ruby %}
class User

 bang :calculate_score => :score

 def calculate_score
   100 # Removed fancy logic for presentational purposes
 end

end
{% endhighlight %}

Now, calling `calculate_score!` will save the results of `calculate_score` to the score attribute. It's one 4-line method in one file and it has a 25-line spec. Simple.

[![MicroGem](http://jeffkreeftmeijer.com/images/microgem.png)](https://gist.github.com/1232884)

After a while, I ran into the same "issue" in another project. I wanted to use my new Bang library, but I didn't want to copy it over to the new project and I didn't feel like starting a new repository on [Github](https://github.com) because that would mean I'd have to write a `README`, squat a name on [RubyGems](http://rubygems.org), accept issues and support it forever. It just felt too small for that.

Instead, [I put the library into a Gist](https://gist.github.com/1232884). The great thing about Gists is that they're full Git repositories in disguise, so I can just clone my library, work on it and push a new "release" without having to fiddle around in Gist's web interface.

To be able to use it as a RubyGem, the only thing I needed to do was add a very, _very_ simple [gemspec](https://gist.github.com/1232884#file_bang.gemspec). The thing you have to keep in mind is that you can't have any directories in Gists (you could, but these files are hidden in the web interface). This means your gemspec will be a bit different from what you normally do. Instead of doing crazy git command magic, you'll set your `files`, `test_file` and `require_path` like this:

{% highlight ruby %}
s.files         = ['bang.rb']
s.test_file     = 'bang_spec.rb'
s.require_path  = '.'
{% endhighlight %}


Using the power of Bundler, I can now require my library in my projects, without even having to push it to RubyGems:

{% highlight ruby %}
gem 'bang', :git => 'git://gist.github.com/1232884.git'
{% endhighlight %}


### Trying this at home

See how easy it is to create your own RubyGem? The only thing you need is an implementation and a gemspec. Since Bang isn't much more than that right now, I think a Gist is sufficient. At least for now.

If your project is bigger than this or has any users besides yourself, you're probably going to have to create a proper Github repository and push it to RubyGems. Gists don't support Github's issues, you can't accept pull requests and you can't use directories. As long as your library doesn't need any of that, I think you'll be fine with something as simple as this.

I've been using my "MicroGem" for a while now and I haven't run into any issues yet. Do you foresee problems with this approach or do you have any ideas to make it even better? Please let me know in the comments!