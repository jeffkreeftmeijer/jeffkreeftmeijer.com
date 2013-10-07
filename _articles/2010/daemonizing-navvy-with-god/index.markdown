<p>In <a href="http://github.com/jeffkreeftmeijer/navvy/tree/v0.2.1">version 0.2.1</a>,  <a href="http://jeffkreeftmeijer.com/navvy">Navvy</a> introduced a <em>really</em> simple <a href="http://daemons.rubyforge.org/">Daemon</a> script to allow users to run Navvy&#8217;s worker in the background.</p>
<p>While some people asked for this, you might argue that running <code>rake navvy:work &amp;</code> would do the exact same thing. It runs the worker, like the rake task does. It only does it in the background, like rake&#8217;s <code>&amp;</code> argument does.</p>
<p>To try and get some more control over my Worker process, I decided to let <a href="http://god.rubyforge.org/">God</a> daemonize it. This allowed me to monitor my process instead of just starting it and hoping it would do it&#8217;s thing. Also, God allows you to set memory limits and automatically restart &#8212; and notify me &#8212; when the worker dies.</p>
<h3>God config</h3>
<p>I&#8217;m assuming you put this block in a <code>Rakefile</code> somewhere to load Navvy&#8217;s tasks:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">begin</span>
  <span class="nb">require</span> <span class="s1">'navvy/tasks'</span>
<span class="k">rescue</span> <span class="no">LoadError</span>
  <span class="n">namespace</span> <span class="ss">:navvy</span> <span class="k">do</span>
    <span class="nb">abort</span> <span class="s2">"Couldn't find Navvy. "</span> <span class="o">&lt;&lt;</span> 
      <span class="s2">"Please run `gem install navvy` to use Navvy's tasks."</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Now, we&#8217;ll create a God configuration file called <code>navvy.god</code> in the same directory as our <code>Rakefile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">God</span><span class="o">.</span><span class="n">watch</span> <span class="k">do</span> <span class="o">|</span><span class="n">w</span><span class="o">|</span>
  <span class="n">w</span><span class="o">.</span><span class="n">name</span>     <span class="o">=</span> <span class="s2">"navvy"</span>
  <span class="n">w</span><span class="o">.</span><span class="n">interval</span> <span class="o">=</span> <span class="mi">30</span><span class="o">.</span><span class="n">seconds</span> <span class="c1"># default</span>
  <span class="n">w</span><span class="o">.</span><span class="n">start</span>    <span class="o">=</span> <span class="s2">"rake navvy:work"</span>
  <span class="n">w</span><span class="o">.</span><span class="n">dir</span>      <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span>
  <span class="n">w</span><span class="o">.</span><span class="n">log</span>      <span class="o">=</span> <span class="s2">"log/navvy.log"</span>

  <span class="c1"># determine the state on startup</span>
  <span class="n">w</span><span class="o">.</span><span class="n">transition</span><span class="p">(</span><span class="ss">:init</span><span class="p">,</span> <span class="p">{</span> <span class="kp">true</span> <span class="o">=&gt;</span> <span class="ss">:up</span><span class="p">,</span> <span class="kp">false</span> <span class="o">=&gt;</span> <span class="ss">:start</span> <span class="p">})</span> <span class="k">do</span> <span class="o">|</span><span class="n">on</span><span class="o">|</span>
    <span class="n">on</span><span class="o">.</span><span class="n">condition</span><span class="p">(</span><span class="ss">:process_running</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">c</span><span class="o">|</span>
      <span class="n">c</span><span class="o">.</span><span class="n">running</span> <span class="o">=</span> <span class="kp">true</span>
    <span class="k">end</span>
  <span class="k">end</span>

  <span class="c1"># determine when process has finished starting</span>
  <span class="n">w</span><span class="o">.</span><span class="n">transition</span><span class="p">(</span><span class="o">[</span><span class="ss">:start</span><span class="p">,</span> <span class="ss">:restart</span><span class="o">]</span><span class="p">,</span> <span class="ss">:up</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">on</span><span class="o">|</span>
    <span class="n">on</span><span class="o">.</span><span class="n">condition</span><span class="p">(</span><span class="ss">:process_running</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">c</span><span class="o">|</span>
      <span class="n">c</span><span class="o">.</span><span class="n">running</span> <span class="o">=</span> <span class="kp">true</span>
      <span class="n">c</span><span class="o">.</span><span class="n">interval</span> <span class="o">=</span> <span class="mi">5</span><span class="o">.</span><span class="n">seconds</span>
    <span class="k">end</span>
  
    <span class="c1"># failsafe</span>
    <span class="n">on</span><span class="o">.</span><span class="n">condition</span><span class="p">(</span><span class="ss">:tries</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">c</span><span class="o">|</span>
      <span class="n">c</span><span class="o">.</span><span class="n">times</span> <span class="o">=</span> <span class="mi">5</span>
      <span class="n">c</span><span class="o">.</span><span class="n">transition</span> <span class="o">=</span> <span class="ss">:start</span>
      <span class="n">c</span><span class="o">.</span><span class="n">interval</span> <span class="o">=</span> <span class="mi">5</span><span class="o">.</span><span class="n">seconds</span>
    <span class="k">end</span>
  <span class="k">end</span>

  <span class="c1"># start if process is not running</span>
  <span class="n">w</span><span class="o">.</span><span class="n">transition</span><span class="p">(</span><span class="ss">:up</span><span class="p">,</span> <span class="ss">:start</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">on</span><span class="o">|</span>
    <span class="n">on</span><span class="o">.</span><span class="n">condition</span><span class="p">(</span><span class="ss">:process_running</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">c</span><span class="o">|</span>
      <span class="n">c</span><span class="o">.</span><span class="n">running</span> <span class="o">=</span> <span class="kp">false</span>
    <span class="k">end</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>This config will start a process called <code>navvy</code>. It&#8217;ll check if the process is still running every 30 seconds and restart it if it isn&#8217;t.</p>
<p>Now, you can start the worker by running:</p>
<pre><code>$ god -c navvy.god</code></pre>
<p>Check the worker&#8217;s status:</p>
<pre><code>$ god status</code></pre>
<p>Or stop it:</p>
<pre><code>$ god stop navvy</code></pre>
<p>Cool, huh?</p>
<h3>What about Navvy&#8217;s daemon script?</h3>
<p>What I&#8217;ve shown you does exactly what Navvy&#8217;s included daemon script does, but keeps monitoring it. If you want more &#8212; like email notifications and memory limits &#8212; check out <a href="http://god.rubyforge.org/">God&#8217;s website</a>.</p>
<p>I&#8217;m thinking about completely removing the daemon script from Navvy in the next version and encouraging users to start using some kind of process monitor, since I believe handling background processes is none of Navvy&#8217;s business. Navvy is a job processor. I think we should focus on that.</p>
<p>What do you think? Your opinion is always welcome.</p>