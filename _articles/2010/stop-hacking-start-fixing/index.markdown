<p>While reading through <a href="http://jeffkreeftmeijer.com/navvy">Navvy</a>&#8217;s <a href="http://github.com/jeffkreeftmeijer/navvy/blob/develop/spec/job_spec.rb">job specs</a>, I found some really ugly <code>Time</code> comparisons:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s1">'should set the created_at date'</span> <span class="k">do</span>
  <span class="ss">Navvy</span><span class="p">:</span><span class="ss">:Job</span><span class="o">.</span><span class="n">enqueue</span><span class="p">(</span><span class="no">Cow</span><span class="p">,</span> <span class="ss">:speak</span><span class="p">,</span> <span class="kp">true</span><span class="p">,</span> <span class="kp">false</span><span class="p">)</span>
  <span class="n">job</span> <span class="o">=</span> <span class="n">first_job</span>
  <span class="n">job</span><span class="o">.</span><span class="n">created_at</span><span class="o">.</span><span class="n">should</span> <span class="n">be_instance_of</span> <span class="no">Time</span>
  <span class="n">job</span><span class="o">.</span><span class="n">created_at</span><span class="o">.</span><span class="n">should</span> <span class="o">&lt;=</span> <span class="no">Time</span><span class="o">.</span><span class="n">now</span>
  <span class="n">job</span><span class="o">.</span><span class="n">created_at</span><span class="o">.</span><span class="n">should</span> <span class="o">&gt;</span> <span class="no">Time</span><span class="o">.</span><span class="n">now</span> <span class="o">-</span> <span class="mi">10</span>
<span class="k">end</span>	
</code></pre>
</div>
<p></p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s1">'should set the run_at date to about 16 seconds from now'</span> <span class="k">do</span>
  <span class="n">failed_job</span> <span class="o">=</span> <span class="ss">Navvy</span><span class="p">:</span><span class="ss">:Job</span><span class="o">.</span><span class="n">enqueue</span><span class="p">(</span><span class="no">Cow</span><span class="p">,</span> <span class="ss">:speak</span><span class="p">,</span> <span class="s1">'name'</span> <span class="o">=&gt;</span> <span class="s1">'Betsy'</span><span class="p">)</span>
  <span class="n">failed_job</span><span class="o">.</span><span class="n">stub!</span><span class="p">(</span><span class="ss">:times_failed</span><span class="p">)</span><span class="o">.</span><span class="n">and_return</span> <span class="mi">2</span>
  <span class="n">now</span> <span class="o">=</span> <span class="no">Time</span><span class="o">.</span><span class="n">now</span>
  <span class="n">job</span> <span class="o">=</span> <span class="n">failed_job</span><span class="o">.</span><span class="n">retry</span>
  <span class="n">job</span><span class="o">.</span><span class="n">run_at</span><span class="o">.</span><span class="n">to_i</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="p">(</span><span class="n">now</span> <span class="o">+</span> <span class="mi">16</span><span class="p">)</span><span class="o">.</span><span class="n">to_i</span>
<span class="k">end</span>
</code></pre>
</div>
<p></p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s1">'should mark the job as complete when keep is true'</span> <span class="k">do</span>
  <span class="ss">Navvy</span><span class="p">:</span><span class="ss">:Job</span><span class="o">.</span><span class="n">keep</span> <span class="o">=</span> <span class="kp">true</span>
  <span class="n">jobs</span> <span class="o">=</span> <span class="ss">Navvy</span><span class="p">:</span><span class="ss">:Job</span><span class="o">.</span><span class="n">next</span>
  <span class="n">jobs</span><span class="o">.</span><span class="n">first</span><span class="o">.</span><span class="n">run</span>
  <span class="n">job_count</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="mi">1</span>
  <span class="n">jobs</span><span class="o">.</span><span class="n">first</span><span class="o">.</span><span class="n">started_at</span><span class="o">.</span><span class="n">should</span> <span class="n">be_instance_of</span> <span class="no">Time</span>
  <span class="n">jobs</span><span class="o">.</span><span class="n">first</span><span class="o">.</span><span class="n">completed_at</span><span class="o">.</span><span class="n">should</span> <span class="n">be_instance_of</span> <span class="no">Time</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Are you laughing? That&#8217;s fine, it&#8217;s funny. But please think about the last time <em>you</em> did something like this while you&#8217;re rolling over the floor in laughter. You&#8217;re probably just as guilty as I am.</p>
<h3>You&#8217;re doing it wrong</h3>
<p>Let&#8217;s go over some problems, starting with the first code snippet.</p>
<p><code>Navvy::Job.enqueue</code> creates a new job in the database and we want to be sure it sets the <code>created_at</code> field. So we create a job and check it&#8217;s <code>created_at</code> value. Great.</p>
<p>We don&#8217;t know exactly how long it will take to create the job, so we create it and check it the <code>created_at</code> is an instance of <code>Time</code>, if it&#8217;s less than <code>Time.now</code> and less than 10 seconds ago.</p>
<p>It never happened to me, but what would happen if &#8212; for some strange reason &#8212; the job would take more than 10 seconds to be created? In that case something is obviously wrong, but it has <em>nothing</em> to do with the <code>created_at</code> value. That&#8217;ll probably be just fine.</p>
<p>The second one is nasty as well. We want to rerun the job after sixteen seconds if it already failed twice, so we create a job and mock out the <code>.times_failed</code> method to return <code>2</code>. After that, we set the <code>time</code> variable to <code>Time.now</code>. We call <code>.retry</code> on the job and expect the <code>run_at</code> value to be 16 seconds more than our <code>time</code> variable.</p>
<p>Again: wrong. Theoretically, it could be possible that <code>.retry</code> takes more than a second. In that case, our test will fail.</p>
<p>In the last snippet, I seem to have given up hope. The test just checks if <code>started_at</code> and <code>failed_at</code> are instances of <code>Time</code>. It doesn&#8217;t really care what it is, it could be ten years in the past. Useless.</p>
<h3>I guess I should have told him to &#8220;Freeze&#8221;.</h3>
<p><sub>No more <a href="http://www.imdb.com/title/tt0111438/quotes">Timecop quotes</a>, promise.</sub></p>
<p>I did <a href="http://github.com/jeffkreeftmeijer/navvy/commit/6bde639b13ff11f1756eca39e5cde93cdd83a853">this commit</a> to clean up the mess a bit, using <a href="http://twitter.com/jtrupiano" title="John Trupiano">@jtrupiano</a>&#8217;s <a href="http://github.com/jtrupiano/timecop">Timecop</a> to &#8220;freeze&#8221; time:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">before</span> <span class="k">do</span>
  <span class="no">Timecop</span><span class="o">.</span><span class="n">freeze</span><span class="p">(</span><span class="no">Time</span><span class="o">.</span><span class="n">local</span><span class="p">(</span><span class="mi">2010</span><span class="p">,</span> <span class="mi">1</span><span class="p">,</span> <span class="mi">1</span><span class="p">))</span>
<span class="k">end</span>

<span class="n">after</span> <span class="k">do</span>
  <span class="no">Timecop</span><span class="o">.</span><span class="n">return</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Since Timecop froze <code>Time.now</code>, it&#8217;ll always return January 1<sup>st</sup> 2010, midnight. This means the first code snippet I showed you can be changed to this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s1">'should set the created_at date'</span> <span class="k">do</span>
  <span class="ss">Navvy</span><span class="p">:</span><span class="ss">:Job</span><span class="o">.</span><span class="n">enqueue</span><span class="p">(</span><span class="no">Cow</span><span class="p">,</span> <span class="ss">:speak</span><span class="p">,</span> <span class="kp">true</span><span class="p">,</span> <span class="kp">false</span><span class="p">)</span>
  <span class="n">job</span> <span class="o">=</span> <span class="n">first_job</span>
  <span class="n">job</span><span class="o">.</span><span class="n">created_at</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="no">Time</span><span class="o">.</span><span class="n">now</span>
<span class="k">end</span>
</code></pre>
</div>
<p>I didn&#8217;t know Timecop existed when I started building Navvy, but I didn&#8217;t search for it either. Instead, I wrote ugly and brittle tests that happened to do the job.</p>
<p>My point is: If you run into a problem like this, find a solution. Somebody out there probably had the same problem before. If not, think of a great solution yourself and release it. Somebody might run into the same problem in the future and thank you for the amazing work you did to make their life easier:</p>
<p>Thanks John, Timecop is awesome!</p>