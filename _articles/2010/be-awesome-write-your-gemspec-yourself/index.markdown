<p><a href="http://github.com/technicalpickles/jeweler">Jeweler</a> is an awesome tool that gives you a generator to quickly set up the main skeleton for building a RubyGem. It has a bunch of rake tasks that make generating, creating, pushing and releasing your gem super easy without having to deal with the scary stuff. It&#8217;s great for anyone that thinks they don&#8217;t know or understand how to build a gem.</p>
<p>I&#8217;m taking Jeweler as an example here. There are a lot of gem builders out there that do the same thing, I just think Jeweler is the one most people know or use. This is <em>not</em> a Jeweler hate campaign, it&#8217;s about gem builders in general.</p>
<p>Half a year ago, the gems I released were all built and maintained using Jeweler, so I put my gem&#8217;s information in a <code>Rakefile</code> and  generated my <code>.gemspec</code> &#8212; the file used to build the actual gem &#8212; from that. I published &#8220;<a href="http://jeffkreeftmeijer.com/2010/gitignore-your-gemspec">.gitignore your *.gemspec</a>&#8221;, arguing that the <code>.gemspec</code> shouldn&#8217;t be checked into source control, since it was a generated file.</p>
<p>After getting a lot of responses and reading <a href="http://twitter.com/wycats">@wycats</a>&#8217; <a href="http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended">article</a>, I realized that generating the <code>.gemspec</code> file was silly, I completely changed my mind about the whole issue and wrote a follow up titled &#8220;<a href="http://jeffkreeftmeijer.com/2010/dont-put-your-gemspec-in-your-rakefile/">Don&#8217;t put your *.gemspec in your Rakefile</a>&#8221;. I&#8217;ve been manually maintaining my <code>.gemspec</code>s ever since.</p>
<p>A lot of people are still using (tools like) Jeweler, which is fine. I would like to ask you to take a look at <a href="http://github.com/jeffkreeftmeijer/navvy/blob/develop/navvy.gemspec">a simple <code>.gemspec</code></a> file sometime and ask yourself if this would more difficult to write and maintain than a <code>Rakefile</code> specifying the exact same thing. I feel like a lot of people are using Jeweler because everyone did it when they started and haven&#8217;t looked back since.</p>
<p>Do we <em>need</em> this extra layer of abstraction? Doesn&#8217;t generating <code>.gemspec</code>s make everything more cumbersome? Is the <code>Rakefile</code> the correct place for your gem specification?</p>
<h3>The new kid in town</h3>
<p>If you read <a href="http://twitter.com/ryanbigg">@ryanbigg</a>&#8217;s great &#8220;<a href="http://github.com/radar/guides/blob/master/gem-development.md">Developing a RubyGem using Bundler</a>&#8221; guide, you probably know that <a href="http://gembundler.com">Bundler</a> can also bootstrap your RubyGem using its <code>gem</code> command:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> bundle gem my_gem
</code></pre>
</div>
<p>It&#8217;ll give you everything you need &#8212; like the <code>.gitignore</code>, <code>Rakefile</code>, <code>Gemfile</code> and <code>.gemspec</code> &#8212; but it puts your gem specification right where it belongs: directly in your <code>.gemspec</code>. Also, it sets up a <code>Gemfile</code> that automatically  gets its dependencies from the <code>.gemspec</code> file, like I explained <a href="http://jeffkreeftmeijer.com/2010/bundler-because-your-gems-depend-on-gems-too/">before</a>.</p>
<p>For a more detailed explanation, check out <a href="http://github.com/radar/guides/blob/master/gem-development.md">Ryan&#8217;s guide</a>.</p>
<h3>Time to move on</h3>
<p>While Jeweler and the like were wicked-cool back in the day, I think it&#8217;s time to move on. Maintaining writing a <code>.gemspec</code> yourself isn&#8217;t difficult at all and you don&#8217;t need a tool to generate one for you, look:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span><span class="p">(</span><span class="s2">"../lib/your_gem/version"</span><span class="p">,</span> <span class="bp">__FILE__</span><span class="p">)</span>

<span class="ss">Gem</span><span class="p">:</span><span class="ss">:Specification</span><span class="o">.</span><span class="n">new</span> <span class="k">do</span> <span class="o">|</span><span class="n">gem</span><span class="o">|</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">name</span>    <span class="o">=</span> <span class="s1">'your_gem'</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">version</span> <span class="o">=</span> <span class="ss">YourGem</span><span class="p">:</span><span class="ss">:VERSION</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">date</span>    <span class="o">=</span> <span class="no">Date</span><span class="o">.</span><span class="n">today</span><span class="o">.</span><span class="n">to_s</span>

  <span class="n">gem</span><span class="o">.</span><span class="n">summary</span> <span class="o">=</span> <span class="s2">"an awesome gem"</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">description</span> <span class="o">=</span> <span class="s2">"extended description"</span>

  <span class="n">gem</span><span class="o">.</span><span class="n">authors</span>  <span class="o">=</span> <span class="o">[</span><span class="s1">'Me Myself'</span><span class="p">,</span> <span class="s1">'One Other'</span><span class="o">]</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">email</span>    <span class="o">=</span> <span class="s1">'me@example.com'</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">homepage</span> <span class="o">=</span> <span class="s1">'http://github.com/user/your_gem'</span>

  <span class="n">gem</span><span class="o">.</span><span class="n">add_dependency</span><span class="p">(</span><span class="s1">'rake'</span><span class="p">)</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">add_development_dependency</span><span class="p">(</span><span class="s1">'rspec'</span><span class="p">,</span> <span class="o">[</span><span class="s2">"&gt;= 2.0.0"</span><span class="o">]</span><span class="p">)</span>

  <span class="c1"># ensure the gem is built out of versioned files</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">files</span> <span class="o">=</span> <span class="no">Dir</span><span class="o">[</span><span class="s1">'Rakefile'</span><span class="p">,</span> <span class="s1">'{bin,lib,man,test,spec}/**/*'</span><span class="p">,</span> <span class="s1">'README*'</span><span class="p">,</span> <span class="s1">'LICENSE*'</span><span class="o">]</span> <span class="o">&amp;</span> <span class="sb">`git ls-files -z`</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s2">"</span><span class="se">\0</span><span class="s2">"</span><span class="p">)</span>
<span class="k">end</span>
</code></pre>
</div>
<p>If you like to have a tool to set up a gem skeleton for you, I would suggest using Bundler. It&#8217;s the cleanest gem builder I&#8217;ve come across so far.</p>
<p>What do you think? Do you prefer treating your <code>.gemspec</code> as a generated file? Do you use a gem builder? Let me know in the comments.</p>