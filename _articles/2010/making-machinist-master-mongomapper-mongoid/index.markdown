<p>A couple of months back, I wrote a minimal <a href="http://github.com/nmerouze/machinist_mongo/commit/dad976b321881657753d50d37bd151b268ab91bd">install guide</a> for <a href="http://github.com/nmerouze/machinist_mongo">machinist_mongo</a> by <a href="http://twitter.com/nmerouze">@nmerouze</a> and <a href="http://twitter.com/shingara">@shingara</a>. Back then it was called machinist_mongomapper, it didn’t support <a href="http://mongoid.com">Mongoid</a> yet and the Rails beta hadn’t even been released yet, so I think it’s about time for an update.</p>
<p>You know <a href="http://github.com/notahat/machinist">Machinist</a>, right? Here’s the short explanation:</p>
<blockquote>“Fixtures aren’t fun. Machinist is.<br><br>
Machinist makes it easy to create test data within your tests. It generates data for the fields you don’t care about, and constructs any necessary associated objects, leaving you to only specify the fields you do care about in your tests.”</blockquote>
<p>I’m not going to go into Machinist itself here, so be sure to read the <a href="http://github.com/notahat/machinist"><span class="caps">README</span></a>.</p>
<p>On to installing machinist_mongo. Put this in your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">gem</span> <span class="s1">'machinist_mongo'</span>
</code></pre>
</div>
<p>And run:</p>
<pre><code>$ bundle install</code></pre>
<p>Or — if you’re using Rails 2.x — put this in <code>config/environment.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'machinist_mongo'</span>
</code></pre>
</div>
<p>And run:</p>
<pre><code>$ rake gems:install</code></pre>
<p>Now create your <code>spec/blueprints.rb</code> or <code>test/blueprints.rb</code> file as you normally would, only using <a href="http://mongoid.com">Mongoid</a> or <a href="http://mongomapper.com">MongoMapper</a> instead of ActiveRecord:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'machinist/mongo_mapper'</span> <span class="c1"># or mongoid</span>
<span class="nb">require</span> <span class="s1">'sham'</span>
</code></pre>
</div>
<p>Don’t forget to require the new <code>blueprints.rb</code> file in your <code>spec_helper</code> (or <code>test_helper</code>):</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span><span class="p">(</span><span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span> <span class="o">+</span> <span class="s2">"/blueprints"</span><span class="p">)</span>
</code></pre>
</div>
<p>And you’re all set. Again, be sure read <a href="http://github.com/notahat/machinist">Machinist’s <span class="caps">README</span></a> to find out how to create your objects and get this thing running.</p>
<p>machinist_mongo aims to support <em>all</em> <a href="http://www.mongodb.org/">mongoDB</a> ORMs, so If you’re using something other than MongoMapper or Mongoid, please be sure to write a adapter for it. Also, can anyone tell me why this isn’t merged into Machinist itself? Because I think it should.</p>