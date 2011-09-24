---
layout: post
title: Isolated testing for custom validators in Rails 3
excerpt: Blazingly fast specs by testing Rails 3 custom validators without requiring the model
published: true
---

It's [International Talk Like A Pirate Day](http://www.talklikeapirate.com/) today, so you might want to add a custom validation to check if comments submitted in your application actually sound like they were written by a pirate. Right? Right. I thought so. Anyway, let's create a validator with specs that don't need to require the model every time they run, allowing them to be blazingly fast. Or, at least faster than what you did before.

![Pirate](http://jeffkreeftmeijer.com/images/pirate.jpg)

Since we care about keeping our test suite nice and fast, we'll try not to load the `Comment` model and anything else we don't really need. Instead of throwing the tests for our validator in the `Comment`'s model spec, we'll create a new one in `spec/validators/pirate_validator_spec.rb` and put a mock model named `Validatable` in there to test with:

{% highlight ruby %}
class Validatable
  include ActiveModel::Validations
  validates_with PirateValidator
end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/8d730b568c5ad7440e008439d85ccdb98c0b9ea6">https://gist.github.com/1226439/8d730b...</a></span>

Running it right now (yes, without any actual tests) would end us up with a `NameError`, telling us `ActiveModel` is uninitialized. We'll need to require it:

{% highlight ruby %}
require 'active_model'
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/66dc63860e02aee4ea2f4fa9afcf0f94d59737e0">https://gist.github.com/1226439/66dc63...</a></span>

When running it again, we quickly find out the `PirateValidator` is uninitialized, since we didn't create and require it yet. Let's put an empty validator in `app/validators/pirate_validator.rb` (and don't forget to require it in the spec):

{% highlight ruby %}
class PirateValidator < ActiveModel::Validator
end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/b5a45ce614cf49b8d0f6a6fc8c50b85d5b739290">https://gist.github.com/1226439/b5a45c...</a></span>

Now the spec actually runs without stumbling on any errors, so we can start writing our first test:

{% highlight ruby %}
describe PirateValidator do

  subject { Validatable.new }

  context 'with a comment that sounds like a pirate' do

    before { subject.stub(:comment).and_return('Ahoy, matey!') }

    it { should be_valid }

  end

end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/be72a980ae6026b4ac7e0d260c416c0a10b66bc9">https://gist.github.com/1226439/be72a9...</a></span>

Running the spec again, we get a `NotImplementedError`:

    NotImplementedError:
      Subclasses must implement a validate(record) method.

Ah, our `PirateValidator` doesn't have a `validate` method yet, so we'll just add an empty one:

{% highlight ruby %}
class PirateValidator < ActiveModel::Validator
  def validate(document)
  end
end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/a1c73c4106977410e54fe10e4c09c5f9a26bebd4">https://gist.github.com/1226439/a1c73c...</a></span>

Wait, what? Our first spec passes, since it asserts the `Validatable` object to be valid and our validator doesn't do anything yet. Let's add another test to give it some actual functionality:

{% highlight ruby %}
context 'with a comment that sounds like a dinosaur' do

  before { subject.stub(:comment).and_return('ROOOAAAR!') }

  it { should have(1).error_on(:comment) }

end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/d29923c4a42530e4dc669e0849e1715481954141">https://gist.github.com/1226439/d29923...</a></span>

Which causes another `NoMethodError`:

    NoMethodError:
      undefined method `error_on' for #<Validatable:0x007faa43462ec8>

That's because we use `should have(1).error_on(:comment)` in our spec, and `error_on` comes with [rspec-rails](https://github.com/rspec/rspec-rails) and we haven't included that yet. `error_on` is in [`RSpec::Rails::Extensions`](https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/extensions/active_record/base.rb), so let's just require that:

{% highlight ruby %}
require 'rspec/rails/extensions'
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/3c5f4b1e539e30ef8b1d423a273ef952c9a70843">https://gist.github.com/1226439/3c5f4b...</a></span>

If we run our tests again, we notice that they're quite a bit slower now. We could solve that by not using the `error_on` method and not requiring `RSpec::Rails::Extensions`, but I prefer using `error_on` instead of having to do assertions on the `subject.errors` array, but that's completely up to you.

_Update_: If you don't want to load up `RSpec::Rails::Extensions`, but do want to use `error_on`, just put [this validations support file](https://gist.github.com/1239170) in `spec/support/validations.rb` and `require 'support/validations'` instead of `rspec/rails/extensions`. This is saving me about 2 seconds.

After requiring `RSpec::Rails::Extensions`, our spec starts running again and fails, because we haven't implemented the actual validation yet. So let's do that now:

{% highlight ruby %}
class PirateValidator < ActiveModel::Validator
  def validate(document)
    unless document.comment.include? 'matey'
      document.errors[:comment] << 'does not sound like a pirate'
    end
  end
end
{% endhighlight %}

<span class="small"><a href="https://gist.github.com/1226439/7a79aa385ae18b0418e2319383c3481bd9452caa">https://gist.github.com/1226439/7a79aa...</a></span>

And our test passes! We successfully implemented a model validator without actually loading the model in the specs. Now, getting it running in your model is up to you, but that shouldn't be more difficult than getting it to run in `Validatable`.

If you have any questions or suggestions about this approach to test validators, be sure to let me know in the comments.. _Matey_.