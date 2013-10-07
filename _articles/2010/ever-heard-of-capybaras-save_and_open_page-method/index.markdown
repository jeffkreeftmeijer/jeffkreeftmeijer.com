<p>Every once in a while, when running acceptance tests, you get this weird failure and <a href="http://github.com/jnicklas/capybara">Capybara</a> can&#8217;t really tell you what&#8217;s wrong either:</p>
<div class="highlight">
<pre><code class="console"><span class="go">1) User registration should register successfully</span>
<span class="go">   Failure/Error: fill_in 'username', :with =&gt; 'jkreeftmeijer'</span>
<span class="go">   cannot fill in, no text field, text area or password field with id, name, or label 'username' found</span>
<span class="go">   # ./spec/acceptance/user_registration_spec.rb:46</span>
</code></pre>
</div>
<p>All we know now is that there&#8217;s no &#8220;username&#8221; field on the page, which doesn&#8217;t really tell us anything. We could start our server and browse to the page manually or &#8212; when using <a href="http://seleniumhq.org">Selenium</a> &#8212; add a <code>sleep</code> right before the spec fails to get a quick glance at what&#8217;s going wrong. Nasty. Don&#8217;t do that.</p>
<h3>save_and_open_page</h3>
<p>When going through Capybara&#8217;s source last week, I found the <code>save_and_open_page</code> method which does a great job at fixing this issue. As the name implies: it saves the page &#8212; complete with styling and images &#8212; and opens it in your favorite browser:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">it</span> <span class="s1">'should register successfully'</span> <span class="k">do</span>
  <span class="n">visit</span> <span class="n">registration_page</span>
  <span class="n">save_and_open_page</span>
  <span class="n">fill_in</span> <span class="s1">'username'</span><span class="p">,</span> <span class="ss">:with</span> <span class="o">=&gt;</span> <span class="s1">'jkreeftmeijer'</span>
<span class="k">end</span>
</code></pre>
</div>
<p>I hope this helps someone, it would have saved me a <em>lot</em> of time.</p>