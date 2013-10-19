<p>Imagine you&#8217;re running your whole <a href="https://github.com/rspec/rspec">RSpec</a> spec suite and the first or second spec fails. You have about two hundred specs to go, but you want to dive in and fix that first failure right away. You&#8217;d probably interrupt the run to get the failure details to go fix them, right?</p>
<p>While this works most of the time (you might get some problems interrupting the run when using <a href="http://seleniumhq.org/">Selenium</a>) wouldn&#8217;t it be awesome if RSpec could automatically stop and output when running into the first failure?</p>
<p><img src="http://jeffkreeftmeijer.com/images/fusebox.jpg" alt=""></p>
<p>Aside from a <a href="http://rubyforge.org/pipermail/rspec-users/2007-July/002376.html">three year old thread in the rspec-users group</a>, I couldn&#8217;t find a lot of useful data. So I set out to write something myself.</p>
<h3>Fail-fast</h3>
<p>I started poking around in the RSpec source and accidentally stumbled on <a href="http://relishapp.com/rspec/rspec-core/">RSpec&#8217;s generated documentation on Relish</a>, where I found <a href="http://relishapp.com/rspec/rspec-core/v/2-0/dir/configuration/fail-fast">the <code>fail_fast</code> configuration option</a> that got introduced in <a href="http://rubygems.org/gems/rspec-core/versions/2.0.0.rc">rspec-core 2.0.0.rc</a>. It actually does <em>exactly</em> what I wanted to achieve.</p>
<p>The <code>fail_fast</code> option will cause RSpec to immediately stop running your specs and output the failure details whenever it fails for the first time, giving you a nice speed boost when trying to fix some spec fails. Usage is pretty straightforward:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># spec/spec_helper.rb</span>

<span class="no">RSpec</span><span class="o">.</span><span class="n">configure</span> <span class="k">do</span> <span class="o">|</span><span class="n">c</span><span class="o">|</span>
  <span class="n">c</span><span class="o">.</span><span class="n">fail_fast</span> <span class="o">=</span> <span class="kp">true</span>
<span class="k">end</span>
</code></pre>
</div>
<h3>Command line support</h3>
<p>Since you probably still want to run your whole spec suite without using the <code>fail_fast</code> option from time to time, setting it in <code>spec/spec_helper.rb</code> isn&#8217;t really a great option. So I added a <a href="https://github.com/rspec/rspec-core/issues/issue/219">command line option</a> so you can use it whenever you want:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> bundle <span class="nb">exec </span>rspec spec/ --fail-fast
<span class="go">.F</span>

<span class="go">Failures:</span>
<span class="go">  1) Swinger should set the Capybara driver</span>
<span class="go">     Failure/Error: Capybara.current_driver.should_not == :rack_test</span>

<span class="go">Finished in 0.00479 seconds</span>
<span class="go">2 examples, 1 failure</span>
</code></pre>
</div>
<p>The <code>--fail-fast</code> option was only <a href="http://blog.davidchelimsky.net/2010/11/07/rspec-21-is-released/">released</a> yesterday as a part of RSpec 2.1, so don&#8217;t forget to update.</p>