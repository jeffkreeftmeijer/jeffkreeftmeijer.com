<p>I came across “<a href="http://jumpstartlab.com/news/archives/2013/04/23/the-death-of-ifs">The Death of Ifs</a>” last week, in which <a href="http://twitter.com/franklinwebber" title="Franklin Webber">@franklinwebber</a> explains the steps he took when refactoring this piece of code to try to get rid of the if statement;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="k">if</span> <span class="n">input</span> <span class="o">==</span> <span class="s1">'q'</span>
    <span class="nb">puts</span> <span class="s1">'Goodbye'</span>
  <span class="k">elsif</span> <span class="n">input</span> <span class="o">==</span> <span class="s1">'tweet'</span>
    <span class="nb">puts</span> <span class="s1">'tweeting'</span>
  <span class="k">elsif</span> <span class="n">input</span> <span class="o">==</span> <span class="s1">'dm'</span>
    <span class="nb">puts</span> <span class="s1">'direct messaging'</span>
  <span class="k">elsif</span> <span class="n">input</span> <span class="o">==</span> <span class="s1">'help'</span>
    <span class="nb">puts</span> <span class="s1">'helping'</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/9d509d6e1ce7e1550d89c2c58fbd2fdeeb862158">https://gist.github.com/5478520/9d509d…</a></span>
<p>The video starts out by explaining that if statements like this one might be a sign of bad design, and that this piece of code will probably grow over time and become an eyesore. While I don’t think the possibility of something growing over time and becoming an eyesore sometime in the future is a good reason to start making the code more extensible, I do believe that this code could use some refactoring.</p>

<p>Franklin starts out by moving some of the code to a seperate class named <code>QuitCommand</code>;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">QuitCommand</span>
  <span class="k">def</span> <span class="nf">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
    <span class="n">input</span> <span class="o">==</span> <span class="s1">'q'</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">exectute</span>
    <span class="nb">puts</span> <span class="s1">'Goodbye'</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>After creating a class for every one of the options in the if statement above, we have <code>QuitCommand</code>, <code>TweetCommand</code>, <code>DirectMessageCommand</code> and <code>HelpCommand</code>, and we can update the <code>#process</code> method we started out with to look like this;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">quit</span> <span class="o">=</span> <span class="no">QuitCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">tweet</span> <span class="o">=</span> <span class="no">TweetCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">dm</span> <span class="o">=</span> <span class="no">DirectMessageCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">help</span> <span class="o">=</span> <span class="no">HelpCommand</span><span class="o">.</span><span class="n">new</span>

  <span class="k">if</span> <span class="n">quit</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span> 
    <span class="n">quit</span><span class="o">.</span><span class="n">execute</span>
  <span class="k">elsif</span> <span class="n">tweet</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span> 
    <span class="n">tweet</span><span class="o">.</span><span class="n">execute</span>
  <span class="k">elsif</span> <span class="n">dm</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
    <span class="n">dm</span><span class="o">.</span><span class="n">execute</span>
  <span class="k">elsif</span> <span class="n">help</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
    <span class="n">help</span><span class="o">.</span><span class="n">execute</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/7e6ad6774e44c17920caf9a126d4686ffa065189">https://gist.github.com/5478520/7e6ad6…</a></span>
<p>As you can see, the if statement is still there, but now the commands have all been abstracted into their own classes, which splits responsibilities and allows you to test them in isolation and extend the execution of the commands without having to touch any other parts of our application.</p>

<p>Franklin then gets to work on that pesky if statement;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">quit</span> <span class="o">=</span> <span class="no">QuitCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">tweet</span> <span class="o">=</span> <span class="no">TweetCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">dm</span> <span class="o">=</span> <span class="no">DirectMessageCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">help</span> <span class="o">=</span> <span class="no">HelpCommand</span><span class="o">.</span><span class="n">new</span>

  <span class="n">commands</span> <span class="o">=</span> <span class="o">[</span><span class="n">quit</span><span class="p">,</span> <span class="n">tweet</span><span class="p">,</span> <span class="n">dm</span><span class="p">,</span> <span class="n">help</span><span class="o">]</span>

  <span class="n">found_command</span> <span class="o">=</span> <span class="n">commands</span><span class="o">.</span><span class="n">find</span> <span class="k">do</span> <span class="o">|</span><span class="n">command</span><span class="o">|</span> 
    <span class="n">command</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="n">found_command</span><span class="o">.</span><span class="n">execute</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/66770439c9beb7e63fea8f9dc3253486a312082e">https://gist.github.com/5478520/667704…</a></span>
<p>By putting the command instances into an array and using <code>Enumerable#find</code>, we can find the first instance that returns true from its <code>#match</code> method to get the command we need. Then we can simply call <code>#execute</code> on it.</p>

<p>But, because <code>found_command</code> could potentially be <code>nil</code> if somebody passes an unknown value, Franklin creates a new command class he names <code>NoActionCommand</code> that has a <code>#match</code> method which always returns true, and an empty <code>#execute</code> method. By putting it last in the commands list in <code>#process</code>, it will always be chosen when the other command classes don’t match. Because we can safely call <code>#execute</code> on an instance of <code>NoActionCommand</code>, the code will now work, even if <code>input</code> is something unexpected;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">NoActionCommand</span>
  <span class="k">def</span> <span class="nf">match?</span>
    <span class="kp">true</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">execute</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">quit</span> <span class="o">=</span> <span class="no">QuitCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">tweet</span> <span class="o">=</span> <span class="no">TweetCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">dm</span> <span class="o">=</span> <span class="no">DirectMessageCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">help</span> <span class="o">=</span> <span class="no">HelpCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">no_action</span> <span class="o">=</span> <span class="no">NoActionCommand</span><span class="o">.</span><span class="n">new</span>
  
  <span class="n">commands</span> <span class="o">=</span> <span class="o">[</span><span class="n">quit</span><span class="p">,</span> <span class="n">tweet</span><span class="p">,</span> <span class="n">dm</span><span class="p">,</span> <span class="n">help</span><span class="p">,</span> <span class="n">no_action</span><span class="o">]</span>

  <span class="n">found_command</span> <span class="o">=</span> <span class="n">commands</span><span class="o">.</span><span class="n">find</span> <span class="k">do</span> <span class="o">|</span><span class="n">command</span><span class="o">|</span> 
    <span class="n">command</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="n">found_command</span><span class="o">.</span><span class="n">execute</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/33215c0c993e361e68bab76568de7fa0a5afb26f">https://gist.github.com/5478520/33215c…</a></span>
<p>There. No more if statements, and the code works exactly like before. Franklin splits the <code>#process</code> method up some more in his video, but let’s take another look to see if we can clean this up some more.</p>

<p>For example, doesn’t having to implement <code>NoActionCommand</code> show that using <code>Enumerable#find</code> is not the best solution to choose one of the commands? Wouldn’t it be simpler and cleaner just to make sure <code>found_command</code> is not <code>nil</code> before trying to call <code>#execute</code> on it? I’d probably do something like this;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">quit</span> <span class="o">=</span> <span class="no">QuitCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">tweet</span> <span class="o">=</span> <span class="no">TweetCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">dm</span> <span class="o">=</span> <span class="no">DirectMessageCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="n">help</span> <span class="o">=</span> <span class="no">HelpCommand</span><span class="o">.</span><span class="n">new</span>

  <span class="n">commands</span> <span class="o">=</span> <span class="o">[</span><span class="n">quit</span><span class="p">,</span> <span class="n">tweet</span><span class="p">,</span> <span class="n">dm</span><span class="p">,</span> <span class="n">help</span><span class="o">]</span>

  <span class="n">found_command</span> <span class="o">=</span> <span class="n">command</span><span class="o">.</span><span class="n">find</span> <span class="k">do</span> <span class="o">|</span><span class="n">command</span><span class="o">|</span> 
    <span class="n">command</span><span class="o">.</span><span class="n">match?</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="n">found_command</span><span class="o">.</span><span class="n">execute</span> <span class="k">if</span> <span class="n">found_command</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/fe5a045c70b84c1c05eb7dcb7ca8f06fedcd6be1">https://gist.github.com/5478520/fe5a04…</a></span>
<p>Not taking the if statement refactoring idea too seriously, we can get rid of our <code>NoActionCommand</code> class again, which removes of a lot of dummy code we don’t really need.</p>

<p>Going a bit further, while I agree on moving the commands to their own separate classes when they’ve grown to a size where that’s sensible, I don’t think it’s a good idea to have those classes, which are in charge of <em>executing</em> the commands, decide which command should be chosen for which input. Personally, I would keep the command selection in the <code>#process</code> method and use an a bit more functional approach;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">commands</span> <span class="o">=</span> <span class="p">{</span>
    <span class="s1">'q'</span> <span class="o">=&gt;</span> <span class="no">GoodbyeCommand</span><span class="o">.</span><span class="n">new</span>
    <span class="s1">'tweet'</span> <span class="o">=&gt;</span> <span class="no">TweetingCommand</span><span class="o">.</span><span class="n">new</span>
    <span class="s1">'dm'</span> <span class="o">=&gt;</span> <span class="no">DirectMessageCommand</span><span class="o">.</span><span class="n">new</span>
    <span class="s1">'help'</span> <span class="o">=&gt;</span> <span class="no">HelpingCommand</span><span class="o">.</span><span class="n">new</span>
  <span class="p">}</span>
  
  <span class="k">if</span> <span class="n">command</span> <span class="o">=</span> <span class="n">commands</span><span class="o">[</span><span class="n">input</span><span class="o">]</span>
    <span class="n">command</span><span class="o">.</span><span class="n">execute</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/3be249c8b70f9ce968b7d368d047fe95b60c838d">https://gist.github.com/5478520/3be249…</a></span>
<p>And, until there would be an actual reason to go that far, I would refactor the if statement we started out with to something that’s easier to maintain, and maybe even easier to <em>understand</em>. Without worrying too much about what might happen in the future, we could try to turn the code into the simplest thing that works, and that would end me up with something like this;</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">process</span><span class="p">(</span><span class="n">input</span><span class="p">)</span>
  <span class="n">commands</span> <span class="o">=</span> <span class="p">{</span>
    <span class="s1">'q'</span> <span class="o">=&gt;</span> <span class="s1">'Goodbye'</span><span class="p">,</span>
    <span class="s1">'tweet'</span> <span class="o">=&gt;</span> <span class="s1">'tweeting'</span><span class="p">,</span>
    <span class="s1">'dm'</span> <span class="o">=&gt;</span> <span class="s1">'direct messaging'</span><span class="p">,</span>
    <span class="s1">'help'</span> <span class="o">=&gt;</span> <span class="s1">'helping'</span>
  <span class="p">}</span>
  
  <span class="k">if</span> <span class="n">command</span> <span class="o">=</span> <span class="n">commands</span><span class="o">[</span><span class="n">input</span><span class="o">]</span>
    <span class="nb">puts</span> <span class="n">command</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/5478520/eeef47f24e7e9fbb0e802e6b667253cc827e0f75">https://gist.github.com/5478520/eeef47…</a></span>