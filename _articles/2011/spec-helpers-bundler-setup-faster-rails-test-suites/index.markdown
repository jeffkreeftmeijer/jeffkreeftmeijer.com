<p>The <code>spec_helper.rb</code> file rspec-rails generates is convenient, as it sets up everything you need to get your tests running. In your actual test, all you have to do is <code>require "spec_helper"</code> and off you go. After waiting for a while.</p>

<p><img alt="Bundler.setup instead of Bundler.require" src="http://jeffkreeftmeijer.com/images/bundler_setup.png"></p>

<p>Your <code>spec_helper</code> is probably slowing your tests down quite a bit while it doesn&#8217;t have to. To get an idea of how long it&#8217;s taking, let&#8217;s just time it (if you&#8217;re following along, I&#8217;d love to know how long yours takes to load in the comments):</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> <span class="nb">time </span>ruby spec/spec_helper.rb
<span class="go">ruby spec/spec_helper.rb  16.38s user 1.83s system 92% cpu 19.691 total</span>
</code></pre>
</div>
<p>For <a href="http://codebrawl.com">Codebrawl</a>, that&#8217;s almost twenty seconds. Not to run the suite, but just to require everything needed. Wow. Also remember that this spec helper is being required even when running model specs.</p>

<p>Let&#8217;s try to speed up a fairly simple spec for the <code>User</code> model. The first thing I do is rip out the <code>require "spec_helper"</code> line and run the spec. That ends me up with a couple of failures due to the model not being loaded and some missing requirements, so I add them to the top of my spec file:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'mongoid'</span>
<span class="nb">require</span> <span class="s1">'gravtastic'</span>
<span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span><span class="p">(</span><span class="s1">'app/models/user'</span><span class="p">)</span>
<span class="nb">require</span> <span class="s1">'shoulda-matchers'</span>
</code></pre>
</div>
<p>There. The spec&#8217;s running again and not requiring the spec helper gave me a six second speed boost, cutting off about 30% of my setup time. You might argue that that&#8217;s still too long, but let&#8217;s keep that for another blogpost.</p>

<h3 id="taking_it_one_step_further">Taking it one step further</h3>

<p>There&#8217;s a line like this in the spec helper rspec-rails generates:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span><span class="p">(</span><span class="s2">"../../config/environment"</span><span class="p">,</span> <span class="bp">__FILE__</span><span class="p">)</span>
</code></pre>
</div>
<p>That line loads up the Rails environment file which, in turn, will require <code>config/application.rb</code>. In there, you can find a line like one of these:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">Bundler</span><span class="o">.</span><span class="n">require</span> <span class="o">*</span><span class="no">Rails</span><span class="o">.</span><span class="n">groups</span><span class="p">(</span><span class="ss">:assets</span> <span class="o">=&gt;</span> <span class="sx">%w(development test)</span><span class="p">)</span>
<span class="c1"># or</span>
<span class="no">Bundler</span><span class="o">.</span><span class="n">require</span><span class="p">(</span><span class="ss">:default</span><span class="p">,</span> <span class="ss">:assets</span><span class="p">,</span> <span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="p">)</span>
</code></pre>
</div>
<p>That line takes care of requiring the gems you added to your <code>:default</code> and <code>:test</code> groups in your Gemfile (in test mode) so you don&#8217;t have to require anything in your models, for instance.</p>

<p>By not loading up a spec helper, not loading Rails and not running <code>Bundler.require</code>, like we just did in our spec, we need to take care of loading gems ourselves. In the example above, I just required the gems I needed in the <code>User</code> model spec. That&#8217;s probably not the best place to put them, since the test should not handle the model&#8217;s requirements. The model should require the libraries it needs itself, right?</p>

<h3 id="bundlersetup_instead_of_bundlerrequire">Bundler.setup instead of Bundler.require</h3>

<p>If we change the <code>Bundler.require</code> call to a <code>Bundler.setup</code> one, Bundler won&#8217;t require any gems in <code>config/application.rb</code> and will leave that all up to you:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">Bundler</span><span class="o">.</span><span class="n">setup</span> <span class="o">*</span><span class="no">Rails</span><span class="o">.</span><span class="n">groups</span><span class="p">(</span><span class="ss">:assets</span> <span class="o">=&gt;</span> <span class="sx">%w(development test)</span><span class="p">)</span>
<span class="c1"># or</span>
<span class="no">Bundler</span><span class="o">.</span><span class="n">setup</span><span class="p">(</span><span class="ss">:default</span><span class="p">,</span> <span class="ss">:assets</span><span class="p">,</span> <span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="p">)</span>
</code></pre>
</div>
<p>Now, run your tests. It might be a good idea to use <a href="http://jeffkreeftmeijer.com/2010/making-rspec-stop-operation-immediately-after-failing/">RSpec&#8217;s fail fast</a> option here, because stuff is going to break. Simply add a <code>require</code> wherever needed to get your tests running properly again. If you get stuck, just take a look at <a href="https://github.com/codebrawl/codebrawl/commit/9df324809cc6e39495af9c78407a6fefed02b7e0">my changes in Codebrawl</a>.</p>

<p>After doing that, you can remove the model&#8217;s requirements from your <code>User</code> spec file and only leave the spec&#8217;s requirements:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span><span class="p">(</span><span class="s1">'app/models/user'</span><span class="p">)</span>
<span class="nb">require</span> <span class="s1">'shoulda-matchers'</span>
</code></pre>
</div>
<p>From now on, your application&#8217;s parts handle their requirements themselves instead of relying on Bundler to have them preloaded. This will allow you to load up one of your models without having to worry about its requirements. So, if your model needs Mongoid, it&#8217;ll require it itself.</p>

<p>Have any comments, questions or great ideas? Did this approach work for you? Or not? Be sure to let me know in the comments!</p>