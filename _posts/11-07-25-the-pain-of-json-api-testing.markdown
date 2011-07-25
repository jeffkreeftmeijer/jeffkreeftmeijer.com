---
layout: post
title: The pain of JSON API testing
excerpt: Is JSON API testing really that painful or are we just using the wrong tools for the job?
published: true
---

I'm a little behind on my blog feeds, so I didn't read [Collective Idea](http://collectiveidea.com/)'s [article](http://collectiveidea.com/blog/archives/2011/07/12/test-your-api-with-cucumber-and-json_spec/) about [json_spec](https://github.com/collectiveidea/json_spec) until yesterday. They created a gem which provides some RSpec matchers and Cucumber steps to do JSON API testing, since "They can be a joy to build but a pain to test". In this article, I want to take a step back and see exactly how painful it is to test a JSON API.

Since I don't agree that testing an API with Cucumber is a good idea, we'll do it in plain RSpec. I'll get back on that at the end of this article.

So, let's say we have a Rails application and our client -- or our users -- want an API to fetch and create data. We'll need an API with a user index and a create action for that, so let's get started with the index. Please note that I'm _not_ checking response codes and not doing anything with authentication. You'll probably have to, so your spec will turn out a bit longer than the example below, but stuff like that is beyond the scope of this article.

{% highlight ruby %}
before do
  @users = [
    User.create!(:name => 'Alice', :login => 'alice'),
    User.create!(:name => 'Bob', :login => 'bob')
  ]
end

context 'fetching the list of users' do

  subject do
    get '/api/users.json'
    JSON.parse(response.body)
  end

  it 'should return a list of users' do
    should == [
      {:name => 'Alice', :login => 'alice'},
      {:name => 'Bob', :login => 'bob'}
    ]
  end

end
{% endhighlight %}

First, in the `before` block, we create two users, since we need something to fetch from our user index API. After that, we use the `get` method to do a GET request to `/api/users.json`. The response body it returns is a string and we won't hurt ourselves by trying to do comparisons on that, so we convert it into a Ruby hash using `JSON.parse`. Since Ruby 1.9 has ordered hashes now, we can simply compare the JSON response hash to our desired result which we put in another hash.

That's quite simple right? Let's create a quick API action that allows us to create a user.

{% highlight ruby %}
    context 'creating a new user' do

      it 'should add one user' do
        lambda {
          post '/api/users.json', :user => {:name => 'Charlie', :login => 'charlie'}
        }.should change(User, :count).by(1)
      end

      context 'after creating, the new user' do

        before do
          post '/api/users.json', :user => {:name => 'Charlie', :login => 'charlie'}
          @user = User.last
        end

        subject { JSON.parse(response.body) }

        it 'should have the correct name and login' do
          @user.name.should == 'Charlie'
          @user.login.should == 'charlie'
        end

        it 'should be returned' do
          should == {'login' => 'charlie', 'name' => 'Charlie'}
        end

      end

    end
{% endhighlight %}

In our first spec, we use `post` to POST some data to the same URL we used above, which will create a new user. We test if that really happens by asking the `User` model if its `count` changed by 1.

Making sure a user is created is not enough, we need to test if our new user has the correct name and login values. In the second spec, we do just that by fetching the last user -- since we already know a user was created -- and checking its `name` and `login` methods.

The last thing we want our user creation API to do is to return our new user. Like the user index spec above, we parse the response body and compare is to another hash.

See how easy that was? JSON might be a difficult format to do tests on, but hashes aren't. If you convert that JSON string to something we can actually work with, the pain goes away quickly and we're off testing our API.

### Cucumber? Why?

If you've been here before, you probably know I'm not Cucumber's greatest fan, but let's put that aside for a bit. If you ask me, Cucumber's greatest feature is what it calls its "business readable DSL", which allows you to write your tests in English. These tests are understandable for non-technical stakeholders, so they can read what the code is doing. A test written with json_spec's Cucumber steps doesn't really do that, since it's full of domain specific stuff:

{% highlight cucumber %}
    Scenario: User list
      Given I post to "/users.json" with:
        """
        {
          "first_name": "Steve",
          "last_name": "Richert"
        }
        """
      And I keep the JSON response at "id" as "USER_ID"
      When I get "/users.json"
      Then the JSON response should have 1 user
      And the JSON response at "0" should be:
        """
        {
          "id": %{USER_ID},
          "first_name": "Steve",
          "last_name": "Richert"
        }
        """
{% endhighlight %}

"A step description should never contain regexen, CSS or XPath selectors, any kind of code or data structure. It should be easily understood just by reading the description." -- [You're Cuking it wrong](http://elabs.se/blog/15-you-re-cuking-it-wrong)

If you _have_ to use data structures in your tests, maybe it's a good idea to put Cucumber aside for a bit. No matter how much you like using it.
