---
layout: post
title: On the death of ifs
excerpt: As a response to an article named &ldquo;The death of ifs&rdquo;, we'll try to refactor a method with a long if statement, without too much overengineering.
published: true
---

I came across &ldquo;[The Death of Ifs](http://jumpstartlab.com/news/archives/2013/04/23/the-death-of-ifs)&rdquo; last week, in which [@franklinwebber](http://twitter.com/franklinwebber "Franklin Webber") explains the steps he took when refactoring this piece of code to try to get rid of the if statement;

{% highlight ruby %}
def process(input)
  if input == 'q'
    puts 'Goodbye'
  elsif input == 'tweet'
    puts 'tweeting'
  elsif input == 'dm'
    puts 'direct messaging'
  elsif input == 'help'
    puts 'helping'
  end
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/9d509d6e1ce7e1550d89c2c58fbd2fdeeb862158">https://gist.github.com/5478520/9d509d…</a></span>

The video starts out by explaining that if statements like this one might be a sign of bad design, and that this piece of code will probably grow over time and become an eyesore. While I don't think the possibility of something growing over time and becoming an eyesore sometime in the future is a good reason to start making the code more extensible, I do believe that this code could use some refactoring.

Franklin starts out by moving some of the code to a seperate class named `QuitCommand`;

{% highlight ruby %}
class QuitCommand
  def match?(input)
    input == 'q'
  end

  def exectute
    puts 'Goodbye'
  end
end
{% endhighlight %}

After creating a class for every one of the options in the if statement above, we have `QuitCommand`, `TweetCommand`, `DirectMessageCommand` and `HelpCommand`, and we can update the `#process` method we started out with to look like this;

{% highlight ruby %}
def process(input)
  quit = QuitCommand.new
  tweet = TweetCommand.new
  dm = DirectMessageCommand.new
  help = HelpCommand.new

  if quit.match?(input) 
    quit.execute
  elsif tweet.match?(input) 
    tweet.execute
  elsif dm.match?(input)
    dm.execute
  elsif help.match?(input)
    help.execute
  end
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/7e6ad6774e44c17920caf9a126d4686ffa065189">https://gist.github.com/5478520/7e6ad6…</a></span>

As you can see, the if statement is still there, but now the commands have all been abstracted into their own classes, which splits responsibilities and allows you to test them in isolation and extend the execution of the commands without having to touch any other parts of our application. 

Franklin then gets to work on that pesky if statement;

{% highlight ruby %}
def process(input)
  quit = QuitCommand.new
  tweet = TweetCommand.new
  dm = DirectMessageCommand.new
  help = HelpCommand.new

  commands = [quit, tweet, dm, help]

  found_command = commands.find do |command| 
    command.match?(input)
  end

  found_command.execute
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/66770439c9beb7e63fea8f9dc3253486a312082e">https://gist.github.com/5478520/667704…</a></span>

By putting the command instances into an array and using `Enumerable#find`, we can find the first instance that returns true from its `#match` method to get the command we need. Then we can simply call `#execute` on it.

But, because `found_command` could potentially be `nil` if somebody passes an unknown value, Franklin creates a new command class he names `NoActionCommand` that has a `#match` method which always returns true, and an empty `#execute` method. By putting it last in the commands list in `#process`, it will always be chosen when the other command classes don't match. Because we can safely call `#execute` on an instance of `NoActionCommand`, the code will now work, even if `input` is something unexpected;

{% highlight ruby %}
class NoActionCommand
  def match?
    true
  end

  def execute
  end
end

def process(input)
  quit = QuitCommand.new
  tweet = TweetCommand.new
  dm = DirectMessageCommand.new
  help = HelpCommand.new
  no_action = NoActionCommand.new
  
  commands = [quit, tweet, dm, help, no_action]

  found_command = commands.find do |command| 
    command.match?(input)
  end

  found_command.execute
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/33215c0c993e361e68bab76568de7fa0a5afb26f">https://gist.github.com/5478520/33215c…</a></span>

There. No more if statements, and the code works exactly like before. Franklin splits the `#process` method up some more in his video, but let's take another look to see if we can clean this up some more.

For example, doesn't having to implement `NoActionCommand` show that using `Enumerable#find` is not the best solution to choose one of the commands? Wouldn't it be simpler and cleaner just to make sure `found_command` is not `nil` before trying to call `#execute` on it? I'd probably do something like this;

{% highlight ruby %}
def process(input)
  quit = QuitCommand.new
  tweet = TweetCommand.new
  dm = DirectMessageCommand.new
  help = HelpCommand.new

  commands = [quit, tweet, dm, help]

  found_command = command.find do |command| 
    command.match?(input)
  end

  found_command.execute if found_command
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/fe5a045c70b84c1c05eb7dcb7ca8f06fedcd6be1">https://gist.github.com/5478520/fe5a04…</a></span>

Not taking the if statement refactoring idea too seriously, we can get rid of our `NoActionCommand` class again, which removes of a lot of dummy code we don't really need.

Going a bit further, while I agree on moving the commands to their own separate classes when they've grown to a size where that's sensible, I don't think it's a good idea to have those classes, which are in charge of _executing_ the commands, decide which command should be chosen for which input. Personally, I would keep the command selection in the `#process` method and use an a bit more functional approach;

{% highlight ruby %}
def process(input)
  commands = {
    'q' => GoodbyeCommand.new
    'tweet' => TweetingCommand.new
    'dm' => DirectMessageCommand.new
    'help' => HelpingCommand.new
  }
  
  if command = commands[input]
    command.execute
  end
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/3be249c8b70f9ce968b7d368d047fe95b60c838d">https://gist.github.com/5478520/3be249…</a></span>

And, until there would be an actual reason to go that far, I would refactor the if statement we started out with to something that's easier to maintain, and maybe even easier to _understand_. Without worrying too much about what might happen in the future, we could try to turn the code into the simplest thing that works, and that would end me up with something like this;

{% highlight ruby %}
def process(input)
  commands = {
    'q' => 'Goodbye',
    'tweet' => 'tweeting',
    'dm' => 'direct messaging',
    'help' => 'helping'
  }
  
  if command = commands[input]
    puts command
  end
end
{% endhighlight %}
<span class="small"><a href="https://gist.github.com/5478520/eeef47f24e7e9fbb0e802e6b667253cc827e0f75">https://gist.github.com/5478520/eeef47…</a></span>
