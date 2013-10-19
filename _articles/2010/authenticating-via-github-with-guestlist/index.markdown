<p>In last week&#8217;s article &#8212; <a href="http://jeffkreeftmeijer.com/2010/simple-authentication-with-warden">&#8220;Simple authentication with Warden&#8221;</a> &#8212; I explained that I wanted to allow users to log in with their <a href="http://github.com">Github</a> credentials in a little application I&#8217;m working on.</p>
<p>The idea is that everyone with a Github account can simply log into the application by entering their  username and token and we&#8217;ll automatically create an account with information fetched from the <a href="http://develop.github.com">Github <span class="caps">API</span></a>. If the user already exists in our database, we won&#8217;t try to fetch anything. We already stored it.</p>
<p>I started working on it and realized that this may also come in handy for somebody else sometime, so  I named it <a href="http://github.com/jeffkreeftmeijer/guestlist">Guestlist</a> and released it.</p>
<p>The installation is really simple, just throw this in your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">gem</span> <span class="s1">'guestlist'</span>
</code></pre>
</div>
<p>And run:</p>
<pre><code>$ bundle install</code></pre>
<p>Or &#8212; if you&#8217;re using Rails 2.x &#8212; put this in <code>config/environment.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'guestlist'</span>
</code></pre>
</div>
<p>And run:</p>
<pre><code>$ rake gems:install</code></pre>
<p>Include <code>Guestlist</code> in your user model (mine is called <code>User</code>):</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">User</span>
  <span class="c1"># It works with ActiveRecord too. ;)</span>
  <span class="kp">include</span> <span class="ss">MongoMapper</span><span class="p">:</span><span class="ss">:Document</span>
  <span class="kp">include</span> <span class="no">Guestlist</span>

  <span class="n">key</span> <span class="ss">:login</span><span class="p">,</span>           <span class="nb">String</span>
  <span class="n">key</span> <span class="ss">:encrypted_token</span><span class="p">,</span> <span class="nb">String</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Make sure you have both <code>login</code> and <code>encrypted_token</code> fields in your database if you&#8217;re using ActiveRecord (<a href="http://gist.github.com/369610">here&#8217;s a migration</a>), or if you&#8217;re using  <a href="http://mongomapper.com">MongoMapper</a>, add some <code>key</code>s to your model like in the example above.</p>
<p>Believe it or not, you&#8217;re all set. Let&#8217;s try it (you can find your token on the <a href="https://github.com/account">Github account page</a>):</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">User</span><span class="o">.</span><span class="n">authenticate</span> <span class="s1">'github_login'</span><span class="p">,</span> <span class="s1">'github_token'</span>
</code></pre>
</div>
<p>Guestlist will automatically create a new <code>User</code> for you and return that, or false if you&#8217;ve entered a wrong login or token. The user&#8217;s token is stored &#8212; yes, encrypted &#8212; , so next time you log in, it&#8217;ll just authenticate you via the database. If the token changes for some strange reason, Guestlist will update your user record when you log in with your new token.</p>
<p>Also, it works great with <a href="http://jeffkreeftmeijer.com/2010/simple-authentication-with-warden">Warden</a>. Here&#8217;s a strategy you can use:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">authenticate!</span>
  <span class="n">u</span> <span class="o">=</span> <span class="no">User</span><span class="o">.</span><span class="n">authenticate</span><span class="p">(</span>
    <span class="n">params</span><span class="o">[</span><span class="ss">:login</span><span class="o">]</span><span class="p">,</span>
    <span class="n">params</span><span class="o">[</span><span class="ss">:token</span><span class="o">]</span>
  <span class="p">)</span>
  <span class="n">u</span><span class="o">.</span><span class="n">nil?</span> <span class="p">?</span> <span class="nb">fail</span><span class="o">!</span><span class="p">(</span><span class="s2">"Couldn't log in"</span><span class="p">)</span> <span class="p">:</span> <span class="n">success!</span><span class="p">(</span><span class="n">u</span><span class="p">)</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Have fun and don&#8217;t forget to <a href="http://github.com/jeffkreeftmeijer/guestlist/issues">submit your issues</a> or <a href="http://github.com/jeffkreeftmeijer/guestlist">fork the project</a> if you have a great idea.</p>