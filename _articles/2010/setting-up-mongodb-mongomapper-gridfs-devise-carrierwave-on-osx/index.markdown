<div class="notice">
Sorry, this article is a bit outdated. Lucky for you, <a href="http://twitter.com/antekpiechnik">@antekpiechnik</a> wrote <a href="http://antekpiechnik.com/posts/setting-up-carrierwave-file-uploads-using-gridfs-on-rails-3-and-mongoid">a really nice guide</a> in which he uses Mongoid and Rails 3. Be sure to check that out too!
</div>
<p>For a little side project I wanted to experiment with <a href="http://www.mongodb.org/">MongoDB</a> and <a href="http://www.mongodb.org/display/DOCS/GridFS">GridFS</a> on Rails 2.3.5, but it took me a while to get everything up and running.</p>
<p>It wasn&#8217;t really a problem with Mongrel, but as soon as Apache and <a href="http://www.modrails.com/">Passenger</a> came in the picture the problems began.</p>
<h3>The gems</h3>
<p>Development setup:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'carrierwave'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'devise'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'mongo_mapper'</span><span class="p">,</span> <span class="ss">:version</span> <span class="o">=&gt;</span> <span class="s1">'0.7.0'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'mongomapper_ext'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'will_paginate'</span>
</code></pre>
</div>
<p>If you want to use GridFS with MongoDB, make sure you use <a href="http://github.com/jnunemaker/mongomapper">MongoMapper</a> 0.7.0, because later versions cause:</p>
<pre><code>mongo/GridFS not found</code></pre>
<p>Test setup:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'rspec'</span><span class="p">,</span> <span class="ss">:lib</span> <span class="o">=&gt;</span> <span class="s1">'spec'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'rspec-rails'</span><span class="p">,</span> <span class="ss">:lib</span> <span class="o">=&gt;</span> <span class="s1">'spec/rails'</span>

<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'machinist_mongo'</span><span class="p">,</span>
  <span class="ss">:version</span> <span class="o">=&gt;</span> <span class="s1">'1.1.0'</span><span class="p">,</span>
  <span class="ss">:lib</span> <span class="o">=&gt;</span> <span class="s1">'machinist/mongo_mapper'</span>

<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'faker'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'steak'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'capybara'</span>
</code></pre>
</div>
<h3>MongoMapper</h3>
<p>To use <a href="http://github.com/jnunemaker/mongomapper">MongoMapper</a> add the following to your <code>config/initializers</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># config/initializers/mongo_mapper.rb</span>

<span class="c1"># load YAML and connect</span>
<span class="n">database_yaml</span> <span class="o">=</span> <span class="ss">YAML</span><span class="p">:</span><span class="ss">:load</span><span class="p">(</span><span class="no">File</span><span class="o">.</span><span class="n">read</span><span class="p">(</span><span class="no">RAILS_ROOT</span> <span class="o">+</span> <span class="s1">'/config/database.yml'</span><span class="p">))</span>
<span class="k">if</span> <span class="n">database_yaml</span><span class="o">[</span><span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="o">]</span> <span class="o">&amp;&amp;</span> <span class="n">database_yaml</span><span class="o">[</span><span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="o">][</span><span class="s1">'adapter'</span><span class="o">]</span> <span class="o">==</span> <span class="s1">'MongoDB'</span>
  <span class="n">mongo_database</span> <span class="o">=</span> <span class="n">database_yaml</span><span class="o">[</span><span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="o">]</span>
  <span class="no">MongoMapper</span><span class="o">.</span><span class="n">connection</span> <span class="o">=</span> <span class="ss">Mongo</span><span class="p">:</span><span class="ss">:Connection</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="n">mongo_database</span><span class="o">[</span><span class="s1">'host'</span><span class="o">]</span><span class="p">,</span> <span class="mi">27017</span><span class="p">,</span> <span class="ss">:pool_size</span> <span class="o">=&gt;</span> <span class="mi">5</span><span class="p">,</span> <span class="ss">:timeout</span> <span class="o">=&gt;</span> <span class="mi">5</span><span class="p">)</span>
  <span class="no">MongoMapper</span><span class="o">.</span><span class="n">database</span> <span class="o">=</span>  <span class="n">mongo_database</span><span class="o">[</span><span class="s1">'database'</span><span class="o">]</span>
<span class="k">end</span>

<span class="k">if</span> <span class="n">defined?</span><span class="p">(</span><span class="no">PhusionPassenger</span><span class="p">)</span>
   <span class="no">PhusionPassenger</span><span class="o">.</span><span class="n">on_event</span><span class="p">(</span><span class="ss">:starting_worker_process</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">forked</span><span class="o">|</span>
     <span class="no">MongoMapper</span><span class="o">.</span><span class="n">connection</span><span class="o">.</span><span class="n">connect_to_master</span> <span class="k">if</span> <span class="n">forked</span>
   <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>The <code>PusionPassenger</code> section can be removed if you are not planning to run this on Apache and Passenger.</p>
<p>If you <em>do</em> plan to run it, make sure this is in your config. It will make sure new spawned Apache children still have a MongoDB database connection and prevent you from pulling out all your hair.</p>
<p>You can now setup your <code>config/database.yml</code> config. Example:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># config/database.yml</span>

<span class="ss">development</span><span class="p">:</span>
  <span class="ss">adapter</span><span class="p">:</span> <span class="n">mongodb</span>
  <span class="ss">database</span><span class="p">:</span> <span class="n">mmyapp_development</span>
  <span class="ss">host</span><span class="p">:</span> <span class="n">localhost</span>
</code></pre>
</div>
<h3>Devise</h3>
<p>Setting up <a href="http://github.com/plataformatec/devise">Devise</a> is pretty easy, just use the following snippet:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># config/initializers/devise.rb</span>

<span class="no">Devise</span><span class="o">.</span><span class="n">setup</span> <span class="k">do</span> <span class="o">|</span><span class="n">config</span><span class="o">|</span>
  <span class="n">config</span><span class="o">.</span><span class="n">mailer_sender</span> <span class="o">=</span> <span class="s2">"info@example.com"</span>
  <span class="n">config</span><span class="o">.</span><span class="n">orm</span> <span class="o">=</span> <span class="ss">:mongo_mapper</span>
<span class="k">end</span>
</code></pre>
</div>
<p>And use it in your (user) model:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">User</span> <span class="o">&lt;</span> <span class="no">Base</span>
  <span class="kp">include</span> <span class="ss">MongoMapper</span><span class="p">:</span><span class="ss">:Document</span>
  <span class="kp">include</span> <span class="ss">MongoMapperExt</span><span class="p">:</span><span class="ss">:Slugizer</span>

  <span class="n">devise</span> <span class="ss">:registerable</span><span class="p">,</span> <span class="ss">:database_authenticatable</span><span class="p">,</span> <span class="ss">:recoverable</span><span class="p">,</span> <span class="ss">:rememberable</span><span class="p">,</span> <span class="ss">:trackable</span><span class="p">,</span> <span class="ss">:validatable</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Since we are on MongDB you can skip the migrations!</p>
<h3>Carrierwave</h3>
<p>Next up is image uploading, I used <a href="http://github.com/jnicklas/carrierwave">Carrierwave</a>.</p>
<p>Again some configuration, this time make sure that the <code>application_#{Rails.env}</code> is consistent with your <code>database.yml</code> file.</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># config/initializers/carrierwave.rb</span>

<span class="no">CarrierWave</span><span class="o">.</span><span class="n">configure</span> <span class="k">do</span> <span class="o">|</span><span class="n">config</span><span class="o">|</span>
  <span class="n">config</span><span class="o">.</span><span class="n">grid_fs_database</span> <span class="o">=</span> <span class="s2">"application_</span><span class="si">#{</span><span class="no">Rails</span><span class="o">.</span><span class="n">env</span><span class="si">}</span><span class="s2">"</span>
  <span class="n">config</span><span class="o">.</span><span class="n">grid_fs_host</span> <span class="o">=</span> <span class="s1">'localhost'</span>
  <span class="n">config</span><span class="o">.</span><span class="n">grid_fs_access_url</span> <span class="o">=</span> <span class="s2">"/GridFS"</span>
  <span class="n">config</span><span class="o">.</span><span class="n">storage</span> <span class="o">=</span> <span class="ss">:grid_fs</span>
<span class="k">end</span>
</code></pre>
</div>
<p>With Carrierwave configured we can now implement it in our model.</p>
<p>An example is:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Photo</span>
  <span class="nb">require</span> <span class="s1">'carrierwave/orm/mongomapper'</span>
  <span class="kp">include</span> <span class="ss">MongoMapper</span><span class="p">:</span><span class="ss">:Document</span>

  <span class="n">mount_uploader</span> <span class="ss">:image</span><span class="p">,</span> <span class="no">ImageUploader</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Note the <code>mount_uploader</code>. This will tell Carrierwave to look for a file called <code>image_uploader</code> in <code>/app/uploaders/</code>.</p>
<p>That file should contain some of the following:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># app/uploaders/image_uploader.rb</span>
<span class="k">class</span> <span class="nc">ImageUploader</span> <span class="o">&lt;</span> <span class="ss">CarrierWave</span><span class="p">:</span><span class="ss">:Uploader</span><span class="o">::</span><span class="no">Base</span>
  <span class="kp">include</span> <span class="ss">CarrierWave</span><span class="p">:</span><span class="ss">:ImageScience</span>

  <span class="n">storage</span> <span class="ss">:grid_fs</span>

  <span class="k">def</span> <span class="nf">store_dir</span>
    <span class="s2">"files/</span><span class="si">#{</span><span class="n">model</span><span class="o">.</span><span class="n">id</span><span class="si">}</span><span class="s2">"</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">extension_white_list</span>
    <span class="sx">%w(jpg jpeg gif png)</span>
  <span class="k">end</span>

  <span class="n">version</span> <span class="ss">:small_thumb</span> <span class="k">do</span>
    <span class="n">process</span> <span class="ss">:resize_to_fill</span> <span class="o">=&gt;</span> <span class="o">[</span><span class="mi">100</span><span class="p">,</span><span class="mi">100</span><span class="o">]</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>A couple of things are important here, first the <code>storage :grid_fs</code>. It will tell Carrierwave to store the files in GridFS.</p>
<p>Next is the <code>def store_dir</code>. This is used to generate the path to the images.</p>
<pre><code>/GridFS/files/[ID]/[filename].[ext]</code></pre>
<p>Note that the path is prefixed with <code>/GridFS</code>. This is the value we have set in the config of Carrierwave.</p>
<p>To serve out the files from Rails we are using a <a href="http://gist.github.com/264077">GridFS metal</a>. This will increase the speed of image serving.</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># app/metal/grid_fs.rb</span>

<span class="c1"># Rails metal to be used with Carrierwave (GridFS) and MongoMapper</span>

<span class="nb">require</span> <span class="s1">'rubygems'</span>
<span class="nb">require</span> <span class="s1">'mongo'</span>
<span class="nb">require</span> <span class="s1">'mongo/GridFS'</span>

<span class="c1"># Allow the metal piece to run in isolation</span>
<span class="nb">require</span><span class="p">(</span><span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span> <span class="o">+</span> <span class="s2">"/../../config/environment"</span><span class="p">)</span> <span class="k">unless</span> <span class="n">defined?</span><span class="p">(</span><span class="no">Rails</span><span class="p">)</span>

<span class="k">class</span> <span class="nc">GridData</span> <span class="o">&lt;</span> <span class="ss">Rails</span><span class="p">:</span><span class="ss">:Rack</span><span class="o">::</span><span class="no">Metal</span>
  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">call</span><span class="p">(</span><span class="n">env</span><span class="p">)</span>
    <span class="k">if</span> <span class="n">env</span><span class="o">[</span><span class="s2">"PATH_INFO"</span><span class="o">]</span> <span class="o">=~</span> <span class="sr">/^\/GridFS\/(.+)$/</span>
      <span class="n">key</span> <span class="o">=</span> <span class="vg">$1</span>
      <span class="k">if</span> <span class="o">::</span><span class="ss">GridFS</span><span class="p">:</span><span class="ss">:GridStore</span><span class="o">.</span><span class="n">exist?</span><span class="p">(</span><span class="no">MongoMapper</span><span class="o">.</span><span class="n">database</span><span class="p">,</span> <span class="n">key</span><span class="p">)</span>
        <span class="o">::</span><span class="ss">GridFS</span><span class="p">:</span><span class="ss">:GridStore</span><span class="o">.</span><span class="n">open</span><span class="p">(</span><span class="no">MongoMapper</span><span class="o">.</span><span class="n">database</span><span class="p">,</span> <span class="n">key</span><span class="p">,</span> <span class="s1">'r'</span><span class="p">)</span> <span class="k">do</span> <span class="o">|</span><span class="n">file</span><span class="o">|</span>
          <span class="o">[</span><span class="mi">200</span><span class="p">,</span> <span class="p">{</span><span class="s1">'Content-Type'</span> <span class="o">=&gt;</span> <span class="n">file</span><span class="o">.</span><span class="n">content_type</span><span class="p">},</span> <span class="o">[</span><span class="n">file</span><span class="o">.</span><span class="n">read</span><span class="o">]]</span>
        <span class="k">end</span>
      <span class="k">else</span>
        <span class="o">[</span><span class="mi">404</span><span class="p">,</span> <span class="p">{</span><span class="s1">'Content-Type'</span> <span class="o">=&gt;</span> <span class="s1">'text/plain'</span><span class="p">},</span> <span class="o">[</span><span class="s1">'File not found.'</span><span class="o">]]</span>
      <span class="k">end</span>
    <span class="k">else</span>
      <span class="o">[</span><span class="mi">404</span><span class="p">,</span> <span class="p">{</span><span class="s1">'Content-Type'</span> <span class="o">=&gt;</span> <span class="s1">'text/plain'</span><span class="p">},</span> <span class="o">[</span><span class="s1">'File not found.'</span><span class="o">]]</span>
    <span class="k">end</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>An important thing to note is the regex part:</p>
<pre><code>if env["PATH_INFO"] =~ /^\/GridFS\/(.+)$/</code></pre>
<p>The GridFS in the regex is the same as in your Carrierwave config!</p>
<h3>
<span class="caps">OSX</span> and open files</h3>
<p>At some point when I began stress testing MongoDB by requesting a <em>lot</em> of files from GridFS. MongoDB would become unresponsive and eventually crash the Rails application.</p>
<p>After a deep dive into the logs I found out that MongoDB has a lot of files open. More then the 256 that <span class="caps">OSX</span> wil allow by default.</p>
<p>To fix this use the <a href="http://serverfault.com/questions/15564/where-are-the-default-ulimits-specified-on-os-x-10-5">following from serverfault</a>, it will basically set the open files limit a lot higher for <span class="caps">OSX</span>.</p>
<p>To change any of these limits, add a line (you may need to create the file first) to <code>/etc/launchd.conf</code>, the arguments are the same as passed to the <code>launchctl</code> command. For example:</p>
<pre><code>sudo echo "limit maxfiles 1024 unlimited" &gt; /etc/launchd.conf</code></pre>
<p>However <code>launchd</code> has already started your login shell, so the simplest way to make these changes take effect is to restart our machine.</p>
<h3>That&#8217;s it!</h3>
<p>Well that&#8217;s it! you should now have a working Rails 2.3.5 stack with MongoMapper, files served from GridFS, authentication from Devise and image uploading with Carrierwave.</p>