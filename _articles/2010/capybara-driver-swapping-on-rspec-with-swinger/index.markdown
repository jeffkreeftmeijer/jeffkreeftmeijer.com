<div class="notice">Swinger is not maintained anymore, since its functionality is built into Capybara. Check out <a href="http://jeffkreeftmeijer.com/2011/capybara-ate-swinger">Capybara ate Swinger</a> for more information.</div>
<p>If you&#8217;ve been doing the acceptance testing dance for a while, you probably know it can get slow pretty fast. Not necessarily in every driver, but since you wanted awesome javascript stuff in your application you&#8217;ve equipped <a href="http://github.com/jnicklas/capybara">Capybara</a> with <a href="http://seleniumhq.org/">Selenium</a> to actually run your tests in an actual browser. Ouch.</p>
<p>The javascript interaction in your application is minimal, but <em>can&#8217;t</em> be tested <em>without</em> Selenium. The worst part is that it&#8217;s only ten specs. Wouldn&#8217;t it be awesome to only use Selenium for those instead of the whole suite?</p>
<p><img src="http://jeffkreeftmeijer.com/images/capybaras.jpg" alt=""></p>
<p>If you&#8217;re using <a href="http://cukes.info/">Cucumber</a>, <a href="http://github.com/jnicklas/capybara/blob/master/lib/capybara/cucumber.rb">Capybara&#8217;s got your back</a>, making it possible to use <a href="http://github.com/aslakhellesoy/cucumber/wiki/tags">Cucumber&#8217;s tagging feature</a> to simply specify which driver you want to use per example, effectively allowing your Capybara to have multiple partners in one session.</p>
<p>But since you like to think you&#8217;re a rebel and rather test your application in pure Ruby, you&#8217;re using plain <a href="http://github.com/rspec/rspec">RSpec</a> (maybe even with <a href="http://github.com/cavalle/steak">Steak</a>). So you need to do stuff like this when you want to switch drivers:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># `scenario` is an alias for `it`, provided by Steak</span>

<span class="n">scenario</span> <span class="s1">'get a nice greeting'</span> <span class="k">do</span>
  <span class="no">Capybara</span><span class="o">.</span><span class="n">current_driver</span> <span class="o">=</span> <span class="ss">:selenium</span>
  <span class="n">visit</span> <span class="n">homepage</span>
  <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span> <span class="s1">'Welcome'</span>
  <span class="no">Capybara</span><span class="o">.</span><span class="n">reset_current_driver</span>
<span class="k">end</span>
</code></pre>
</div>
<h3>Swinger</h3>
<p><a href="http://github.com/jeffkreeftmeijer/swinger">Swinger</a> is a really simple Capybara extension that aims to make this a bit less horrible to look at. Using <a href="http://blog.davidchelimsky.net/2010/06/14/filtering-examples-in-rspec-2">the new metadata feature in RSpec 2</a>, you can simply set your <code>:driver</code> per scenario or context:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">scenario</span> <span class="s1">'get a nice greeting'</span><span class="p">,</span> <span class="ss">:driver</span> <span class="o">=&gt;</span> <span class="ss">:selenium</span> <span class="k">do</span>
  <span class="n">visit</span> <span class="n">homepage</span>
  <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span> <span class="s1">'Welcome'</span>
<span class="k">end</span>

<span class="n">context</span> <span class="s1">'when logged in'</span><span class="p">,</span> <span class="ss">:driver</span> <span class="o">=&gt;</span> <span class="ss">:rack_test</span> <span class="k">do</span>

  <span class="n">scenario</span> <span class="s1">'get a nice greeting'</span> <span class="k">do</span>
    <span class="n">visit</span> <span class="n">homepage</span>
    <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span> <span class="s1">'Welcome back'</span>
  <span class="k">end</span>

  <span class="n">scenario</span> <span class="s1">'see the logout link'</span> <span class="k">do</span>
    <span class="n">visit</span> <span class="n">homepage</span>
    <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span> <span class="s1">'Logout'</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>It also adds the <code>using_driver</code> method to Capybara, allowing you to execute a block using a specific driver. This is especially useful when you&#8217;re (still) not on RSpec 2 and can&#8217;t use the new metadata feature:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">scenario</span> <span class="s1">'get a nice greeting'</span> <span class="k">do</span>
  <span class="no">Capybara</span><span class="o">.</span><span class="n">using_driver</span> <span class="ss">:selenium</span> <span class="k">do</span>
    <span class="n">visit</span> <span class="n">homepage</span>
    <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span> <span class="s1">'Welcome'</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Installing Swinger is easy. Simply add it to your <code>Gemfile</code> and require it in <code>spec_helper.rb</code>.</p>
<h3>A patch for Capybara?</h3>
<p>Let me know how you like it and be sure to create an <a href="http://github.com/jeffkreeftmeijer/swinger/issues">issue on Github</a>, send me a <a href="https://github.com/inbox/new/jeffkreeftmeijer">Github message</a> or an <a href="http://jeffkreeftmeijer.com/contact/">email</a> if you have any ideas or run into any issues. Of course you can always fork the project and send me a pull request or a patch via email.</p>
<p>Oh, one last thing: I know this is a pretty minimal gem, but I wanted to just get it out there to use it myself and see if it needs any improvement before maybe turning it into a patch for Capybara.</p>
<p>Would you like this to be part of Capybara or do you prefer keeping this a separate gem? Please let me know!</p>