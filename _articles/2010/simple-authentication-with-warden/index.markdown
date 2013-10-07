<p>There are a lot of Ruby authentication libraries out there, which can do about everything like sending confirmation emails and resetting passwords. I didn&#8217;t really want that. My plan was to write a little application that could authenticate using <a href="http://github.com">Github</a> credentials (more on Github authentication in <a href="http://jeffkreeftmeijer.com/2010/authenticating-via-github-with-guestlist">&#8220;Authenticating via Github with Guestlist&#8221;</a>).</p>
<p>This meant I didn&#8217;t need email confirmations, password reset functionality or even registration. Also, I didn&#8217;t want to log in using an email address and password or check my own database to see if the user exists. So, no <a href="http://github.com/binarylogic/authlogic">Authlogic</a> or <a href="http://github.com/thoughtbot/clearance">Clearance</a> for me. I had to go find a more low-level solution.</p>
<p>It didn&#8217;t take long before I found <a href="http://github.com/hassox/warden">Warden</a>, a &#8220;General Rack Authentication Framework&#8221;.</p>
<p><img src="http://jeffkreeftmeijer.com/images/jail.jpg" alt="Warden, General Rack Authentication Framework"></p>
<blockquote>
<p>&#8220;Warden is rack based middleware, designed to provide a mechanism for authentication in Ruby web applications. It is a common mechanism that fits into the Rack Machinery to offer powerful options for authentication.&#8221;</p>
</blockquote>
<p>Remember: it does <em>not</em> do registration, confirmation and the like. If you want anything like that, use <a href="http://github.com/plataformatec/devise">Devise</a>, a Rails authentication system <em>based on</em> Warden. <a href="http://twitter.com/rbates">@rbates</a> also did a <a href="http://railscasts.com/episodes/209-introducing-devise">great Railscast on Devise</a>.</p>
<blockquote>
<p>&#8220;Warden uses the concept of cascading strategies to determine if a request should be authenticated.  Warden will try strategies one after another until either one succeeds, no Strategies are found relevant or a strategy fails.&#8221;</p>
</blockquote>
<p>An example of a <a href="http://wiki.github.com/hassox/warden/strategies">strategy</a> would be a user logging in with his username and password:</p>
<div class="highlight">
<pre><code class="ruby"><span class="ss">Warden</span><span class="p">:</span><span class="ss">:Strategies</span><span class="o">.</span><span class="n">add</span><span class="p">(</span><span class="ss">:my_strategy</span><span class="p">)</span> <span class="k">do</span>
  
  <span class="k">def</span> <span class="nf">valid?</span>
    <span class="n">params</span><span class="o">[</span><span class="ss">:username</span><span class="o">]</span> <span class="o">&amp;&amp;</span> <span class="n">params</span><span class="o">[</span><span class="ss">:password</span><span class="o">]</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">authenticate!</span>
    <span class="n">u</span> <span class="o">=</span> <span class="no">User</span><span class="o">.</span><span class="n">find_by_username_and_password</span><span class="p">(</span>
      <span class="n">params</span><span class="o">[</span><span class="ss">:username</span><span class="o">]</span><span class="p">,</span>
      <span class="n">params</span><span class="o">[</span><span class="ss">:password</span><span class="o">]</span> <span class="c1"># you should encrypt this. ;)</span>
    <span class="p">)</span>
    
    <span class="n">u</span><span class="o">.</span><span class="n">nil?</span> <span class="p">?</span> <span class="nb">fail</span><span class="o">!</span><span class="p">(</span><span class="s2">"Couldn't log in"</span><span class="p">)</span> <span class="p">:</span> <span class="n">success!</span><span class="p">(</span><span class="n">u</span><span class="p">)</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>The <code>valid?</code> method checks if the strategy is valid. In the example above it will return false when the username and password aren&#8217;t both in the params. In that case it will fail without even having to try and find the user.</p>
<p><code>authenticate!</code> calls <code>fail!</code> with a message when the authentication failed. If the authentication passes, it&#8217;ll pass the <code>User</code> instance to <code>success!</code>. Pretty simple.</p>
<p>I&#8217;m not going into any specific stuff here, but if you&#8217;re using Rails you might want to check out <a href="http://github.com/HP/rails_warden_mongoid_example">rails_warden_mongoid_example</a>. It&#8217;s a pretty simple and understandable application that shows you how to use Warden. Also, be sure to read the <a href="http://wiki.github.com/hassox/warden">wiki</a>, it has pretty good <a href="http://wiki.github.com/hassox/warden/setup">setup</a> and <a href="http://wiki.github.com/hassox/warden/examples">example</a> pages and there&#8217;s a lot more cool stuff in there.</p>