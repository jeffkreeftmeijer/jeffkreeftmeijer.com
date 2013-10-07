<p>Tools like <a href="https://github.com/jstorimer/spin">Spin</a> and <a href="https://github.com/sporkrb/spork">Spork</a> help you speed up your test runs by preloading your application’s dependencies and running your test suite without reloading the whole stack each time. That sounds like magic, but it’s actually quite simple to build a tool that can do something like that. In this article, we’ll write a dependency preloader in about twenty lines of Ruby. Ready? Let’s go!</p>

<p>To keep things understandable, We’ll start out with a simple file named <code>test.rb</code>, pretending to be a test file by printing out a hundred dots:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="s1">'slow'</span>

<span class="mi">100</span><span class="o">.</span><span class="n">times</span> <span class="k">do</span>
  <span class="nb">sleep</span> <span class="nb">rand</span> <span class="o">*</span> <span class="mi">0</span><span class="o">.</span><span class="mo">01</span>
  <span class="nb">print</span> <span class="s1">'.'</span>
<span class="k">end</span>
</code></pre>
</div>
<p>It requires a file named <code>slow.rb</code>, which will simulate your suite’s startup time:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">sleep</span> <span class="mi">2</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/2909445/5cabc0559d3a3d9aad90721306bac4aa8f4cfa9b">https://gist.github.com/2909445/5cabc0…</a></span>
<p>As you might have guessed, when you run <code>ruby test.rb</code>, it’ll take two seconds before anything happens. That probably looks a lot like your Rails application’s test suite, right? Now, waiting for two seconds is no real problem unless you’re running your suite multiple times. If you run <code>ruby test.rb</code> three times now, you’ll notice what I mean.</p>

<h3 id="forking">Forking</h3>

<p>In this case, <code>slow.rb</code> is a dependency that doesn’t change too often, like Rails or some other library your application depends on. That means it’s safe to preload it and run the test suite with it a couple of times, instead of reloading it for each run. We can do that by requiring it once and forking the process every time we run our test suite. A simple example of that could look like this, which will run <code>test.rb</code> three times without reloading <code>slow.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="s1">'slow'</span>

<span class="mi">3</span><span class="o">.</span><span class="n">times</span> <span class="k">do</span> 
  <span class="nb">fork</span> <span class="k">do</span> 
    <span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="s1">'test'</span>
  <span class="k">end</span>

  <span class="no">Process</span><span class="o">.</span><span class="n">wait</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/2909445/ec2f2245bb8b8ee411723f02eccaa0e9c1e65f30">https://gist.github.com/2909445/ec2f22…</a></span>
<p>After preloading <code>slow.rb</code> on the first line, we’ll go into a loop which creates a subprocess using <code>fork</code>. We’ll require <code>test.rb</code> in this subprocess and finally, we’ll call <code>Process.wait</code> in the main process, which will halt to wait for the subprocess to exit. Because <code>slow.rb</code> is already required in the main process before forking off, it won’t be loaded again by <code>test.rb</code> in the forked subprocesses.</p>

<h3 id="server">Server</h3>

<p>On to the real thing. To make this usable as an actual tool, we need to turn it into a server that can receive messages and run tests when prompted to. To be able to talk between two Ruby processes, we’ll use <a href="http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html">DRb</a>. Let’s create a file named <code>server.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'drb'</span>
<span class="no">ARGV</span><span class="o">.</span><span class="n">each</span> <span class="p">{</span> <span class="o">|</span><span class="n">file</span><span class="o">|</span> <span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="n">file</span> <span class="p">}</span>
<span class="no">Rails</span><span class="o">.</span><span class="n">env</span> <span class="o">=</span> <span class="s1">'test'</span> <span class="k">if</span> <span class="n">defined?</span> <span class="no">Rails</span> 

<span class="k">class</span> <span class="nc">Runner</span>
  <span class="k">def</span> <span class="nf">run</span><span class="p">(</span><span class="n">files</span><span class="p">)</span>
    <span class="nb">fork</span> <span class="k">do</span>
      <span class="n">files</span><span class="o">.</span><span class="n">each</span> <span class="p">{</span> <span class="o">|</span><span class="n">file</span><span class="o">|</span> <span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="n">file</span> <span class="p">}</span>
    <span class="k">end</span>
    <span class="no">Process</span><span class="o">.</span><span class="n">wait</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="no">DRb</span><span class="o">.</span><span class="n">start_service</span> <span class="s1">'druby://:4321'</span><span class="p">,</span> <span class="no">Runner</span><span class="o">.</span><span class="n">new</span>
<span class="no">DRb</span><span class="o">.</span><span class="n">thread</span><span class="o">.</span><span class="n">join</span>
</code></pre>
</div>
<p>As you can see, <code>Runner#run</code> looks a lot like what we’ve done before. The big difference is that we put it in a class named <code>Runner</code> and started a DRb service with a reference to an instance of it. This allows a client connected to the service to directly call methods on the <code>Runner</code> instance. Let’s create another file, named <code>client.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'drb'</span>

<span class="n">runner</span> <span class="o">=</span> <span class="no">DRbObject</span><span class="o">.</span><span class="n">new</span> <span class="kp">nil</span><span class="p">,</span> <span class="s1">'druby://:4321'</span>
<span class="n">runner</span><span class="o">.</span><span class="n">run</span><span class="p">(</span><span class="no">ARGV</span><span class="p">)</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/2909445/185119a265744aea8d69a1df2fc60fdd7a97164b">https://gist.github.com/2909445/185119a265744aea8…</a></span>
<p>The only thing the client does is create a new <code>DRbObject</code> –which returns the instance of <code>Runner</code> we initialized in <code>server.rb</code>– and call the <code>run</code> method on it.</p>

<p>To try it out, start your server and tell it to preload <code>slow.rb</code>:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> ruby server.rb slow
</code></pre>
</div>
<p>And run our test file using the client in another terminal window:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> ruby client.rb <span class="nb">test</span>
</code></pre>
</div>
<p>As you’ll see, your tests will start almost instantly.</p>

<p>Note: if you want to use your new preloader in a Rails application, you’ll probably want to preload <code>config/application</code>, since that’s the file that starts your application and tells Bundler to require your dependencies.</p>

<p>See how easy it is to preload dependencies instead of loading them before each test run? Of course, this could use a lot of work, but this was just an attempt to show you a really simple way to ease the pain of your application’s startup time when running your tests. If you’re looking for something more polished, check out <a href="https://github.com/jstorimer/spin">Spin</a>, by <a href="http://twitter.com/jstorimer" title="Jesse Storimer">@jstorimer</a>.</p>