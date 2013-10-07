<p>It’s been a while since the last proper release of <a href="http://jeffkreeftmeijer.com/navvy">Navvy</a> — the database agnostic Ruby background job processor — but like I <a href="http://jeffkreeftmeijer.com/2010/rise-of-the-navvy/">promised a while back</a>, I’ve been working on a new version whenever I could find the time.</p>
<p><img src="http://jeffkreeftmeijer.com/images/steam_navvy.jpg" title="Navvy 0.3" alt="Navvy 0.3"></p>
<p>I’m really excited to release <a href="http://rubygems.org/gems/navvy/versions/0.3.0">Navvy 0.3</a> and I think you’re going to love it. It’s <a href="http://www.youtube.com/watch?v=Nx7v815bYUw">great, fantastic, amazing and magical</a> and I’d like to highlight four “tent poles” for you today.</p>
<p>Ok, no more Apple marketing techniques. Promise.</p>
<h3>Mongoid</h3>
<p>In addition to the adapters for <a href="http://api.rubyonrails.org/classes/ActiveRecord/Base.html">ActiveRecord</a>, <a href="http://datamapper.org/">DataMapper</a>, <a href="http://sequel.rubyforge.org/">Sequel</a> and <a href="http://mongomapper.com">MongoMapper</a>, Navvy 0.3 intoduces a <a href="http://mongoid.org/">Mongoid</a> adapter that works exactly like the rest. Special thanks to <a href="http://twitter.com/TomK32">@TomK32</a> and <a href="http://twitter.com/rubenfonseca">@rubenfonseca</a> for helping out.</p>
<h3>Navvy::Logger</h3>
<p>The previous logger — called <code>Navvy::Log</code> — was rather nasty due to some bad design decisions I made a while back, so I decided to completely rewrite it. Now it extends the <a href="http://ruby-doc.org/core/classes/Logger.html">Logger</a> from the standard Ruby library, which makes it more reliable and a lot smaller.</p>
<p>Navvy will log to <code>STDOUT</code> by default, but using <code>Navvy.configure</code> you can provide your own logger:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">Navvy</span><span class="o">.</span><span class="n">configure</span> <span class="k">do</span> <span class="o">|</span><span class="n">config</span><span class="o">|</span>
  <span class="n">config</span><span class="o">.</span><span class="n">logger</span> <span class="o">=</span> <span class="no">Logger</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="s1">'~/navvy.log'</span><span class="p">)</span>
<span class="k">end</span>
</code></pre>
</div>
<h3>Daemons</h3>
<p>As I said in <a href="http://jeffkreeftmeijer.com/2010/daemonizing-navvy-with-god">my previous Navvy article</a>, I want to encourage users to use a process monitor (like <a href="http://god.rubyforge.org/">God</a>) since I believe handling background processes is none of Navvy’s business.</p>
<p>That’s why Navvy’s generator doesn’t create the <code>script/navvy</code> file anymore. Also, the nasty <code>Navvy::Worker.daemonize</code> is gone. If you want to daemonize your worker process, you should set it up yourself now.</p>
<h3>Generators</h3>
<p>Navvy has had a Rails generator to create migrations for a while now, but it was ActiveRecord only. In 0.3, the Rails 2 and Rails 3 generators can create migrations for Sequel as well.</p>
<p>As you probably know, DataMapper, MongoMapper and Mongoid don’t need migrations. That means all generators are really easy to set up now.</p>
<h3>Cleanups</h3>
<p>Last but not least, Navvy got cleaned up quite a bit since 0.2. For example: the gem isn’t built with <a href="http://github.com/technicalpickles/jeweler">Jeweler</a> anymore, which resulted in a cleaner <code>Rakefile</code>, a cleaner <code>.gemspec</code>  and no more need for that nasty <code>VERSION</code> file.</p>
<p>For contributors (<a href="http://wiki.github.com/jeffkreeftmeijer/navvy/contributors">♥</a>), Navvy uses <a href="http://gembundler.com">Bundler</a> now, so you can quickly install everything you need to start hacking on Navvy.</p>
<p>That’s it. Be sure to give Navvy a try some time. The <a href="http://wiki.github.com/jeffkreeftmeijer/navvy/">wiki</a> is quite comprehensive but if you run into any problems, be sure to <a href="http://github.com/inbox/new/jeffkreeftmeijer">ask</a>, or <a href="http://github.com/jeffkreeftmeijer/navvy/issues">create an issue on Github</a>.</p>