<p>I&#8217;m a little behind on my blog feeds, so I didn&#8217;t read <a href="http://collectiveidea.com/">Collective Idea</a>&#8217;s <a href="http://collectiveidea.com/blog/archives/2011/07/12/test-your-api-with-cucumber-and-json_spec/">article</a> about <a href="https://github.com/collectiveidea/json_spec">json_spec</a> until yesterday. They created a gem which provides some RSpec matchers and Cucumber steps to do JSON API testing, since &#8220;They can be a joy to build but a pain to test&#8221;. In this article, I want to take a step back and see exactly how painful it is to test a JSON API.</p>

<p>Since I don&#8217;t agree that testing an API with Cucumber is a good idea, we&#8217;ll do it in plain RSpec. I&#8217;ll get back on that at the end of this article.</p>

<p>So, let&#8217;s say we have a Rails application and our client &#8211; or our users &#8211; want an API to fetch and create data. We&#8217;ll need an API with a user index and a create action for that, so let&#8217;s get started with the index. Please note that I&#8217;m <em>not</em> checking response codes and not doing anything with authentication. You&#8217;ll probably have to, so your spec will turn out a bit longer than the example below, but stuff like that is beyond the scope of this article.</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">before</span> <span class="k">do</span>
  <span class="vi">@users</span> <span class="o">=</span> <span class="o">[</span>
    <span class="no">User</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Alice'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'alice'</span><span class="p">),</span>
    <span class="no">User</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Bob'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'bob'</span><span class="p">)</span>
  <span class="o">]</span>
<span class="k">end</span>

<span class="n">context</span> <span class="s1">'fetching the list of users'</span> <span class="k">do</span>

  <span class="n">subject</span> <span class="k">do</span>
    <span class="n">get</span> <span class="s1">'/api/users.json'</span>
    <span class="no">JSON</span><span class="o">.</span><span class="n">parse</span><span class="p">(</span><span class="n">response</span><span class="o">.</span><span class="n">body</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="n">it</span> <span class="s1">'should return a list of users'</span> <span class="k">do</span>
    <span class="n">should</span> <span class="o">==</span> <span class="o">[</span>
      <span class="p">{</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Alice'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'alice'</span><span class="p">},</span>
      <span class="p">{</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Bob'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'bob'</span><span class="p">}</span>
    <span class="o">]</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>First, in the <code>before</code> block, we create two users, since we need something to fetch from our user index API. After that, we use the <code>get</code> method to do a GET request to <code>/api/users.json</code>. The response body it returns is a string and we won&#8217;t hurt ourselves by trying to do comparisons on that, so we convert it into a Ruby hash using <code>JSON.parse</code>. Since Ruby 1.9 has ordered hashes now, we can simply compare the JSON response hash to our desired result which we put in another hash.</p>

<p>That&#8217;s quite simple right? Let&#8217;s create a quick API action that allows us to create a user.</p>
<div class="highlight">
<pre><code class="ruby">    <span class="n">context</span> <span class="s1">'creating a new user'</span> <span class="k">do</span>

      <span class="n">it</span> <span class="s1">'should add one user'</span> <span class="k">do</span>
        <span class="nb">lambda</span> <span class="p">{</span>
          <span class="n">post</span> <span class="s1">'/api/users.json'</span><span class="p">,</span> <span class="ss">:user</span> <span class="o">=&gt;</span> <span class="p">{</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Charlie'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'charlie'</span><span class="p">}</span>
        <span class="p">}</span><span class="o">.</span><span class="n">should</span> <span class="n">change</span><span class="p">(</span><span class="no">User</span><span class="p">,</span> <span class="ss">:count</span><span class="p">)</span><span class="o">.</span><span class="n">by</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span>
      <span class="k">end</span>

      <span class="n">context</span> <span class="s1">'after creating, the new user'</span> <span class="k">do</span>

        <span class="n">before</span> <span class="k">do</span>
          <span class="n">post</span> <span class="s1">'/api/users.json'</span><span class="p">,</span> <span class="ss">:user</span> <span class="o">=&gt;</span> <span class="p">{</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Charlie'</span><span class="p">,</span> <span class="ss">:login</span> <span class="o">=&gt;</span> <span class="s1">'charlie'</span><span class="p">}</span>
          <span class="vi">@user</span> <span class="o">=</span> <span class="no">User</span><span class="o">.</span><span class="n">last</span>
        <span class="k">end</span>

        <span class="n">subject</span> <span class="p">{</span> <span class="no">JSON</span><span class="o">.</span><span class="n">parse</span><span class="p">(</span><span class="n">response</span><span class="o">.</span><span class="n">body</span><span class="p">)</span> <span class="p">}</span>

        <span class="n">it</span> <span class="s1">'should have the correct name and login'</span> <span class="k">do</span>
          <span class="vi">@user</span><span class="o">.</span><span class="n">name</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="s1">'Charlie'</span>
          <span class="vi">@user</span><span class="o">.</span><span class="n">login</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="s1">'charlie'</span>
        <span class="k">end</span>

        <span class="n">it</span> <span class="s1">'should be returned'</span> <span class="k">do</span>
          <span class="n">should</span> <span class="o">==</span> <span class="p">{</span><span class="s1">'login'</span> <span class="o">=&gt;</span> <span class="s1">'charlie'</span><span class="p">,</span> <span class="s1">'name'</span> <span class="o">=&gt;</span> <span class="s1">'Charlie'</span><span class="p">}</span>
        <span class="k">end</span>

      <span class="k">end</span>

    <span class="k">end</span>
</code></pre>
</div>
<p>In our first spec, we use <code>post</code> to POST some data to the same URL we used above, which will create a new user. We test if that really happens by asking the <code>User</code> model if its <code>count</code> changed by 1.</p>

<p>Making sure a user is created is not enough, we need to test if our new user has the correct name and login values. In the second spec, we do just that by fetching the last user &#8211; since we already know a user was created &#8211; and checking its <code>name</code> and <code>login</code> methods.</p>

<p>The last thing we want our user creation API to do is to return our new user. Like the user index spec above, we parse the response body and compare is to another hash.</p>

<p>See how easy that was? JSON might be a difficult format to do tests on, but hashes aren&#8217;t. If you convert that JSON string to something we can actually work with, the pain goes away quickly and we&#8217;re off testing our API.</p>

<h3 id="cucumber_why">Cucumber? Why?</h3>

<p>If you&#8217;ve been here before, you probably know I&#8217;m not Cucumber&#8217;s greatest fan, but let&#8217;s put that aside for a bit. If you ask me, Cucumber&#8217;s greatest feature is what it calls its &#8220;business readable DSL&#8221;, which allows you to write your tests in English. These tests are understandable for non-technical stakeholders, so they can read what the code is doing. A test written with json_spec&#8217;s Cucumber steps doesn&#8217;t really do that, since it&#8217;s full of domain specific stuff:</p>
<div class="highlight">
<pre><code class="cucumber"><span class="nf">    </span><span class="k">Scenario:</span><span class="nf"> User list</span>
<span class="k">      Given </span><span class="nf">I post to "</span><span class="s">/users.json</span><span class="nf">" with:</span>
<span class="nf">        </span><span class="k">"""</span><span class="s"></span>
<span class="s">        {</span>
<span class="s">          "first_name": "Steve",</span>
<span class="s">          "last_name": "Richert"</span>
<span class="s">        }</span>
<span class="s">        </span><span class="k">"""</span><span class="nf"></span>
<span class="nf">      </span><span class="k">And </span><span class="nf">I keep the JSON response at "</span><span class="s">id</span><span class="nf">" as "</span><span class="s">USER_ID</span><span class="nf">"</span>
<span class="nf">      </span><span class="k">When </span><span class="nf">I get "</span><span class="s">/users.json</span><span class="nf">"</span>
<span class="nf">      </span><span class="k">Then </span><span class="nf">the JSON response should have </span><span class="s">1</span><span class="nf"> user</span>
<span class="nf">      </span><span class="k">And </span><span class="nf">the JSON response at "</span><span class="s">0</span><span class="nf">" should be:</span>
<span class="nf">        </span><span class="k">"""</span><span class="s"></span>
<span class="s">        {</span>
<span class="s">          "id": %{USER_ID},</span>
<span class="s">          "first_name": "Steve",</span>
<span class="s">          "last_name": "Richert"</span>
<span class="s">        }</span>
<span class="s">        </span><span class="k">"""</span><span class="nf"></span>
</code></pre>
</div>
<p>&#8220;A step description should never contain regexen, CSS or XPath selectors, any kind of code or data structure. It should be easily understood just by reading the description.&#8221; &#8211; <a href="http://elabs.se/blog/15-you-re-cuking-it-wrong">You&#8217;re Cuking it wrong</a></p>

<p>If you <em>have</em> to use data structures in your tests, maybe it&#8217;s a good idea to put Cucumber aside for a bit. No matter how much you like using it.</p>