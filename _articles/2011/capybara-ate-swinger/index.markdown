<p>About three months ago, I <a href="http://jeffkreeftmeijer.com/2010/capybara-driver-swapping-on-rspec-with-swinger">released Swinger</a> to add <a href="http://github.com/rspec">RSpec</a> driver swapping to <a href="http://github.com/jnicklas/capybara">Capybara</a>.</p>
<p><img src="http://jeffkreeftmeijer.com/images/capybara.jpg" alt=""></p>
<p>This idea wasn&#8217;t new, Capybara had doing it <a href="https://github.com/jnicklas/capybara/blob/master/lib/capybara/cucumber.rb">for Cucumber</a> for quite some time. Cucumber has this nice tagging thing that allows you to hook in and do cool stuff like that.</p>
<p>RSpec didn&#8217;t have a feature like that until 2.0, when it released the <a href="http://blog.davidchelimsky.net/2010/06/14/filtering-examples-in-rspec-2">metadata feature</a>. That made it possible to pass arbitrary metadata to examples or example groups, allowing you to tag examples. Like in Cucumber. But better.</p>
<p>Using that, I built Swinger for a big project we were working on at <a href="http://80beans.com">80beans</a>. It was still a bit of a monkey patch, since RSpec didn&#8217;t really provide a way to access an example&#8217;s metadata in the around hook, but it worked pretty well.</p>
<p>Not long after relasing it as a separate gem, I turned Swinger into a <a href="https://github.com/jnicklas/capybara/pull/187">Capybara pull request</a>. It was still a monkey patch, so <a href="http://twitter.com/dchelimsky" title="David Chelimsky">@dchelimsky</a> did <a href="https://github.com/rspec/rspec-core/issues/issue/221">a patch for RSpec</a> to expose the metadata in around hooks, which made it possible for <a href="http://twitter.com/jncoward" title="Jonas Nicklas">@jncoward</a> to eventually built a cleaner version of the driver swapping idea into Capybara.</p>
<h3>Driver Swapping in Capybara, without the crap</h3>
<p>Now, since Capybara version <del><a href="http://rubygems.org/gems/capybara/versions/0.4.1">0.4.1</a></del> <a href="http://rubygems.org/gems/capybara/versions/0.4.1.1">0.4.1.1</a>, it supports driver swapping out of the box. Here&#8217;s how to get it working.</p>
<p>First, in the file where you set up Capybara (that&#8217;s <code>spec/acceptance/acceptance_helper.rb</code> if you&#8217;re using <a href="https://github.com/cavalle/steak">Steak</a>). Include Capybara&#8217;s RSpec helper file:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'capybara/rspec'</span>
</code></pre>
</div>
<p>Now, just like with Swinger, you can tag your examples with a specific <code>:driver</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s2">"does fancy stuff"</span><span class="p">,</span> <span class="ss">:driver</span> <span class="o">=&gt;</span> <span class="ss">:selenium</span> <span class="k">do</span>
  <span class="c1"># test fancy stuff</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Of course you can also use this on example groups:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">context</span> <span class="s2">"fancy stuff"</span><span class="p">,</span> <span class="ss">:driver</span> <span class="o">=&gt;</span> <span class="ss">:rack_test</span> <span class="k">do</span>
  <span class="c1"># fancy examples</span>
<span class="k">end</span>
</code></pre>
</div>
<p>If you set <code>Capybara.javascript_driver</code>, you can even tag examples that need a javascript capable driver like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">Capybara</span><span class="o">.</span><span class="n">javascript_driver</span> <span class="o">=</span> <span class="ss">:selenium</span>

<span class="n">it</span> <span class="s2">"does fancy stuff"</span><span class="p">,</span> <span class="ss">:js</span> <span class="o">=&gt;</span> <span class="kp">true</span> <span class="k">do</span>
  <span class="c1"># test fancy stuff</span>
<span class="k">end</span>
</code></pre>
</div>
<p>This officially means I stopped maintaining Swinger and I urge you to update Capybara to 0.4.1.1. Thanks to everyone who helped out building Swinger and getting it into Capybara, it certainly made my test suites a lot faster.</p>