<p>It&#8217;s quite common for testing libraries (like <a href="https://github.com/rspec">RSpec</a> and <a href="https://github.com/chneukirchen/bacon">Bacon</a>) to test themselves. That&#8217;s pretty cool, but it might get you into some problems. In this article I&#8217;ll try to explain one of those problems and give a suggestion that might help.</p>
<p>Instead of showing you a red dot and a failing test, RSpec won&#8217;t be able to run its own tests <em>at all</em> if you break <code>RSpec::Core::Example.run</code>. That shouldn&#8217;t be anything shocking, because that method is very important to be able to actually run an example.</p>
<p><img src="http://jeffkreeftmeijer.com/images/recursion.png" alt=""></p>
<p>The problem we have here is that code you&#8217;re working on is unstable and can&#8217;t be trusted, which means you can&#8217;t really use it to test anything either. That&#8217;s testing broken code with broken code and it can get very confusing very fast.</p>
<p>Here&#8217;s a more simple example. Let&#8217;s say we added a method called <code>#one</code> to <code>Object</code>, allowing us to check the numerical value of &#8216;one&#8217; by just calling <code>#one</code> on any object:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Object</span>
  <span class="k">def</span> <span class="nf">one</span>
    <span class="mi">1</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>We also have a method to check if something&#8217;s value is 1, and we put it conveniently in the same library:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Object</span>
  <span class="k">def</span> <span class="nf">one</span>
    <span class="mi">1</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">is_one?</span>
    <span class="nb">self</span> <span class="o">==</span> <span class="mi">1</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Now, we can write a test that makes our library test its own method:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">one</span><span class="o">.</span><span class="n">is_one?</span>
</code></pre>
</div>
<p>Nice. Now the library is using its <code>#is_one?</code> method to test its <code>#one</code> method. There&#8217;s only one problem though. What if we dive in again and start hacking on our library? We could break <code>#is_one?</code> and end up with something like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Object</span>
  <span class="k">def</span> <span class="nf">one</span>
    <span class="mi">1</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">is_one?</span>
    <span class="nb">self</span> <span class="o">==</span> <span class="mi">2</span> <span class="c1"># oops!</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>This would mean that our test for <code>#one</code> will fail, while it&#8217;s not broken at all. Instead, our test is broken (which happens to be in the library we&#8217;re currently testing).</p>
<p>A solution would be to let a stable version of our library test the current version. Let&#8217;s try that.</p>
<p>In our test, we <code>require</code> the library to be tested first and clone it into a <code>Unstable</code> namespace. After that, we <code>require</code> a stable version of our library:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># library_spec.rb</span>

<span class="nb">require</span> <span class="s1">'library'</span>

<span class="k">module</span> <span class="nn">Unstable</span>
  <span class="no">Object</span> <span class="o">=</span> <span class="o">::</span><span class="no">Object</span><span class="o">.</span><span class="n">clone</span>
<span class="k">end</span>

<span class="nb">require</span> <span class="s1">'stable_library'</span>
</code></pre>
</div>
<p>The stable library has overwritten the <code>Object</code> in the global namespace, but not the <code>Unstable::Object</code>. Now we should call <code>#one</code> from the <code>Unstable</code> namespace instead of the global one (because <code>Unstable::Object</code> is the class we&#8217;re currently testing):</p>
<div class="highlight">
<pre><code class="ruby"><span class="ss">Unstable</span><span class="p">:</span><span class="ss">:Object</span><span class="o">.</span><span class="n">one</span><span class="o">.</span><span class="n">is_one?</span> <span class="c1"># =&gt; 1</span>
</code></pre>
</div>
<p>Because <code>Unstable::Object#one</code> returns a stable <code>Fixnum</code>, our stable version of <code>#is_one?</code> is used. This makes sure our test actually runs, even if the current (unstable) version of our library is broken.</p>
<p>Now we have a setup that uses a stable version of a library that can find bugs in an unstable version of itself. Awesome.</p>
<p>What do you think? Be sure to let me know if you have any ideas to improve this approach.</p>