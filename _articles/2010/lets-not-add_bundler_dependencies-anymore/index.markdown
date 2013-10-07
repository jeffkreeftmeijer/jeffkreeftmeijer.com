<p>The article I published about <a href="http://jeffkreeftmeijer.com/2010/bundler-because-your-gems-depend-on-gems-too/">using Bundler to manage your gem&#8217;s gem dependencies</a> turned out a bit different than I thought. I started writing it because I had a problem with <a href="http://gembundler.com">Bundler</a>&#8217;s <code>add_bundler_dependencies</code> method and I wanted to propose a better way to handle this.</p>
<p>So I went to Bundler&#8217;s amazing little website to read up the nasty feature, but it was <a href="http://www.google.com/search?q=%22add_bundler_dependencies%22+site%3Agembundler.com">gone</a>. After looking around for a second, I found the new &#8220;<a href="http://gembundler.com/rubygems.html">Using Bundler with Rubygem gemspecs</a>&#8221; page and realized a lot had changed since everybody got excited about <code>add_bundler_dependencies</code> at Railsconf.</p>
<p>I ended up writing a cheerful article about how awesome Bundler was, since my biggest annoyance had been destroyed. Now, a couple of weeks later, <a href="http://andre.arko.net/2010/05/01/bundler-for-gem-development">this article about <code>add_bundler_dependencies</code></a> started to get mentioned again. Please allow me to explain why I think you should stop using it.</p>
<h3>Why?</h3>
<p>If you don&#8217;t know, <code>add_bundler_dependencies</code> allows you to make your <code>.gemspec</code> get its dependencies from your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># .gemspec</span>
<span class="nb">require</span> <span class="s1">'bundler'</span>
<span class="ss">Gem</span><span class="p">:</span><span class="ss">:Specification</span><span class="o">.</span><span class="n">new</span> <span class="k">do</span> <span class="o">|</span><span class="n">s</span><span class="o">|</span>
  <span class="n">s</span><span class="o">.</span><span class="n">add_bundler_dependencies</span>
<span class="k">end</span>
</code></pre>
</div>
<p>A very convenient way not to have to specify your dependencies twice, right? The problem with this is that you just added Bundler to your gem&#8217;s dependencies.</p>
<p>This feels totally backwards, since the <code>.gemspec</code> file should be the one specifying Gem dependencies. If you ask me, getting them from the <code>Gemfile</code> instead and adding a dependency is wrong. Bundler should only be needed when you <em>want</em> to do something with the <code>Gemfile</code>, the <code>.gemspec</code> &#8212; and the rest of the gem &#8212; should work without it.</p>
<h3>Gemfiles reading .gemspecs</h3>
<p>The <a href="http://jeffkreeftmeijer.com/2010/bundler-because-your-gems-depend-on-gems-too/">new implementation</a> turns this all around and allows you to let your <code>Gemfile</code> read dependencies from your <code>.gemspec</code>, so you don&#8217;t need Bundler to install it anymore. It&#8217;s a matter of simply throwing <code>gemspec</code> into your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># Gemfile</span>
<span class="n">gemspec</span>
</code></pre>
</div>
<p>Please, let&#8217;s start using that one now. It&#8217;s prettier, it makes more sense and there&#8217;s a reason <code>add_bundler_dependencies</code> isn&#8217;t mentioned on the Bundler website anymore.</p>
<p><del>What do you think about a deprecation warning when still using <code>add_bundler_dependencies</code>? <a href="http://twitter.com/wycats" title="Yehuda Katz">@wycats</a>? <a href="http://twitter.com/carllerche" title="Carl Lerche">@carllerche</a>? Anyone?</del> Oh, it&#8217;ll <a href="http://jeffkreeftmeijer.com/2010/lets-not-add_bundler_dependencies-anymore/#comment-81240290">throw a deprecation warning</a> too.</p>