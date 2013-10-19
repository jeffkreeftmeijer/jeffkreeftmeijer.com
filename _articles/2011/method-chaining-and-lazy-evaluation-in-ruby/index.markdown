<p>Method chaining has been all the rage lately and every database wrapper or aything else that’s uses queries seems to be doing it. But, how does it work? To figure that out, we’ll write a library that can chain method calls to build up a MongoDB query in this article. Let’s get started!</p>

<p>Oh, and don’t worry if you haven’t used MongoDB before, I’m just using it as an example to query on. If you’re using this guide to build a querying library for something else, the MongoDB part should be easy to swap out.</p>

<p>Let’s say we’re working with a user collection and we want to be able to query it somewhat like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="no">User</span><span class="o">.</span><span class="n">where</span><span class="p">(</span><span class="ss">:name</span> <span class="o">=&gt;</span> <span class="s1">'Jeff'</span><span class="p">)</span><span class="o">.</span><span class="n">limit</span><span class="p">(</span><span class="mi">5</span><span class="p">)</span>
</code></pre>
</div>
<p>We’ll create a <code>Criteria</code> class to build queries. As you might have guessed, it needs two instance methods named <code>where</code> and <code>limit</code>.</p>

<p>When calling one of these methods, all our object needs to do is remember the criteria that were passed, so we’ll need to set up an instance variable – named <code>@criteria</code> – to store them in.</p>

<p>Our <code>where</code> method is used to specify conditions and we want it to return an empty array when none have been specified yet, so we’ll add an empty array to our criteria hash by default:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/946ce04625042250697601fd30f269a495a4b4dc">https://gist.github.com/1397738/946ce0…</a></span>
<p>Now we’re able to remember conditions, we need a way to set them. We’ll create a <code>where</code> method that adds its arguments to the conditions array:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">where</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">].</span><span class="n">merge!</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/dacc040f5aeb35a90f5963d3920464fe28642806">https://gist.github.com/1397738/dacc04…</a></span>
<p>Great! Let’s give it a try:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'criteria'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; c = Criteria.new</span>
<span class="go"> =&gt; #&lt;Criteria:0x007ff9db8bf1f0&gt;</span>
<span class="go">ruby-1.9.3-p0 :003 &gt; c.where(:name =&gt; 'Jeff')</span>
<span class="go"> =&gt; {:name=&gt;"Jeff"}</span>
<span class="go">ruby-1.9.3-p0 :004 &gt; c</span>
<span class="go"> =&gt; #&lt;Criteria:0x007ff9db8bf1f0 @criteria={:conditions=&gt;{:name=&gt;"Jeff"}}&gt;</span>
</code></pre>
</div>
<p>As you can see, our <code>Criteria</code> object successfully stores our condition in the <code>@criteria</code> variable. Let’s try to chain another <code>where</code> call:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'criteria'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; c = Criteria.new</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fbf5296d098&gt;</span>
<span class="go">ruby-1.9.3-p0 :003 &gt; c.where(:name =&gt; 'Jeff').where(:login =&gt; 'jkreeftmeijer')</span>
<span class="go">NoMethodError: undefined method `where' for {:name=&gt;"Jeff"}:Hash</span>
<span class="go">    from (irb):3</span>
<span class="go">    from /Users/jeff/.rvm/rubies/ruby-1.9.3-p0/bin/irb:16:in `&lt;main&gt;'</span>
</code></pre>
</div>
<p>Hm. That didn’t work, because <code>where</code> returns a hash and <code>Hash</code> doesn’t have a <code>where</code> method. We need to make sure the <code>where</code> method returns the <code>Criteria</code> object. Let’s update the <code>where</code> method so it returns <code>self</code> instead of the conditions variable:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">where</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">].</span><span class="n">merge!</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="nb">self</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/c5d22217f3856eb5e9e336a27c82874f3801031a">https://gist.github.com/1397738/c5d222…</a></span>
<p>Okay, let’s try it again:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'criteria'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; c = Criteria.new</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fe91117c738&gt;</span>
<span class="go">ruby-1.9.3-p0 :003 &gt; c.where(:name =&gt; 'Jeff').where(:login =&gt; 'jkreeftmeijer')</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fe91117c738 @criteria={:conditions=&gt;{:name=&gt;"Jeff", :login=&gt;"jkreeftmeijer"}}&gt;</span>
</code></pre>
</div>
<p>Ha! Now we can chain as many conditions as we want. Let’s go ahead and implement that <code>limit</code> method right away, so we can limit our query’s results.</p>

<p>Of course, we only need one limit, as multiple limits wouldn’t make sense. This means we don’t need an array, we can just set <code>criteria[:limit]</code> instead of merging hashes, like we did with the conditions before:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">where</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">].</span><span class="n">merge!</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="nb">self</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">limit</span><span class="p">(</span><span class="n">limit</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:limit</span><span class="o">]</span> <span class="o">=</span> <span class="n">limit</span>
    <span class="nb">self</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/d289697a3a85deb9cc3710ddac181bf2e97d8c3b">https://gist.github.com/1397738/d28969…</a></span>
<p>Now we can chain conditions and even throw in a limit:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'criteria'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; c = Criteria.new</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fdb1b0ca528&gt;</span>
<span class="go">ruby-1.9.3-p0 :003 &gt; c.where(:name =&gt; 'Jeff').limit(5)</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fdb1b0ca528 @criteria={:conditions=&gt;{:name=&gt;"Jeff"}, :limit=&gt;5}&gt;</span>
</code></pre>
</div>
<h3 id="the_model">The model</h3>

<p>There. We can collect query criteria now, but we’ll need a model to actually query on. For this example, let’s create a model named <code>User</code>.</p>

<p>Since we’re building a library that can query a MongoDB database, I’ve installed the <a href="https://github.com/mongodb/mongo-ruby-driver">mongo-ruby-driver</a> and added a <code>collection</code> method to the <code>User</code> model:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'mongo'</span>

<span class="k">class</span> <span class="nc">User</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">collection</span>
    <span class="vi">@collection</span> <span class="o">||=</span> <span class="ss">Mongo</span><span class="p">:</span><span class="ss">:Connection</span><span class="o">.</span><span class="n">new</span><span class="o">[</span><span class="s1">'criteria'</span><span class="o">][</span><span class="s1">'users'</span><span class="o">]</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/2b9bd004d7592e51bb698c2f7449771e711c0e35">https://gist.github.com/1397738/2b9bd0…</a></span>
<p>The <code>collection</code> method connects to the “criteria” database, looks up the “users” collection and returns an instance of <code>Mongo::Collection</code>, which we’ll use to query on later.</p>

<p>Remember when I said I wanted to be able to do something like <code>User.where(:name =&gt; 'Jeff').limit(5)</code>? Well, right now our model doesn’t implement <code>where</code> or <code>limit</code>, since we put them in the <code>Criteria</code> class. Let’s fix that by creating two methods on <code>User</code> that delegate to <code>Criteria</code>.</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'mongo'</span>
<span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="s1">'criteria'</span>

<span class="k">class</span> <span class="nc">User</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">collection</span>
    <span class="vi">@collection</span> <span class="o">||=</span> <span class="ss">Mongo</span><span class="p">:</span><span class="ss">:Connection</span><span class="o">.</span><span class="n">new</span><span class="o">[</span><span class="s1">'mongo_chain'</span><span class="o">][</span><span class="s1">'users'</span><span class="o">]</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">limit</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
    <span class="no">Criteria</span><span class="o">.</span><span class="n">new</span><span class="o">.</span><span class="n">limit</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">where</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
    <span class="no">Criteria</span><span class="o">.</span><span class="n">new</span><span class="o">.</span><span class="n">where</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/6035babd3ed2439026c992abc7a12230718a77d1">https://gist.github.com/1397738/6035ba…</a></span>
<p>This allows us to call our criteria methods directly on our model:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'user'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; User.where(:name =&gt; 'Jeff').limit(5)</span>
<span class="go"> =&gt; #&lt;Criteria:0x007fca1c8b0bd0 @criteria={:conditions=&gt;{:name=&gt;"Jeff"}, :limit=&gt;5}&gt;</span>
</code></pre>
</div>
<p>Great. Calling criteria on the <code>User</code> model returns a <code>Criteria</code> object now. But, maybe you already noticed it, the returned object has no idea what to query on. We need to let it know we want to search the users collection. To do that, we need to overwrite the <code>Criteria</code>’s <code>initialize</code> method:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">initialize</span><span class="p">(</span><span class="n">klass</span><span class="p">)</span>
    <span class="vi">@klass</span> <span class="o">=</span> <span class="n">klass</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">where</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">].</span><span class="n">merge!</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="nb">self</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">limit</span><span class="p">(</span><span class="n">limit</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:limit</span><span class="o">]</span> <span class="o">=</span> <span class="n">limit</span>
    <span class="nb">self</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/4e2e0b506dfb7ed171368b7b05b9ae560146c582">https://gist.github.com/1397738/4e2e0b…</a></span>
<p>With a slight change to our model – passing <code>self</code> to <code>Criteria.new</code> –, we can let the <code>Criteria</code> class know what we’re looking for:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'mongo'</span>
<span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">expand_path</span> <span class="s1">'criteria'</span>

<span class="k">class</span> <span class="nc">User</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">collection</span>
    <span class="vi">@collection</span> <span class="o">||=</span> <span class="ss">Mongo</span><span class="p">:</span><span class="ss">:Connection</span><span class="o">.</span><span class="n">new</span><span class="o">[</span><span class="s1">'criteria'</span><span class="o">][</span><span class="s1">'users'</span><span class="o">]</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">limit</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
    <span class="no">Criteria</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="nb">self</span><span class="p">)</span><span class="o">.</span><span class="n">limit</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nc">self</span><span class="o">.</span><span class="nf">where</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
    <span class="no">Criteria</span><span class="o">.</span><span class="n">new</span><span class="p">(</span><span class="nb">self</span><span class="p">)</span><span class="o">.</span><span class="n">where</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/97652e1572efbcc3fe354c45c8905b0fdd975036">https://gist.github.com/1397738/97652e…</a></span>
<p>After a quick test, we can see that the <code>Criteria</code> instance successfully remembers our model class:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'user'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; User.where(:name =&gt; 'Jeff')</span>
<span class="go"> =&gt; #&lt;Criteria:0x007ffdd30d4d68 @klass=User, @criteria={:conditions=&gt;{:name=&gt;"Jeff"}}&gt;</span>
</code></pre>
</div>
<h3 id="getting_some_results">Getting some results</h3>

<p>The last thing we need to do is lazily querying our database and getting some results. To make sure our library doesn’t query before collecting all of the criteria, we’ll wait until <code>each</code> gets called – to loop over the query’s results – on the <code>Criteria</code> instance. Let’s see how our library handles that right now:</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'user'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; User.where(:name =&gt; 'Jeff').each { |u| puts u.inspect }</span>
<span class="go">NoMethodError: undefined method `each' for #&lt;Criteria:0x007fd0540cfea0&gt;</span>
<span class="go">	from (irb):2</span>
<span class="go">	from /Users/jeff/.rvm/rubies/ruby-1.9.3-p0/bin/irb:16:in `&lt;main&gt;'</span>
</code></pre>
</div>
<p>Of course, there’s no method named <code>each</code> on <code>Criteria</code>, because we don’t have anything to loop over yet. We’ll create <code>Criteria#each</code>, which will execute the query, giving us an array of results. We use that array’s <code>each</code> method to pass our block to:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Criteria</span>

  <span class="k">def</span> <span class="nf">initialize</span><span class="p">(</span><span class="n">klass</span><span class="p">)</span>
    <span class="vi">@klass</span> <span class="o">=</span> <span class="n">klass</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">criteria</span>
    <span class="vi">@criteria</span> <span class="o">||=</span> <span class="p">{</span><span class="ss">:conditions</span> <span class="o">=&gt;</span> <span class="p">{}}</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">where</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">].</span><span class="n">merge!</span><span class="p">(</span><span class="n">args</span><span class="p">)</span>
    <span class="nb">self</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">limit</span><span class="p">(</span><span class="n">limit</span><span class="p">)</span>
    <span class="n">criteria</span><span class="o">[</span><span class="ss">:limit</span><span class="o">]</span> <span class="o">=</span> <span class="n">limit</span>
    <span class="nb">self</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">each</span><span class="p">(</span><span class="o">&amp;</span><span class="n">block</span><span class="p">)</span>
    <span class="vi">@klass</span><span class="o">.</span><span class="n">collection</span><span class="o">.</span><span class="n">find</span><span class="p">(</span>
      <span class="n">criteria</span><span class="o">[</span><span class="ss">:conditions</span><span class="o">]</span><span class="p">,</span> <span class="p">{</span><span class="ss">:limit</span> <span class="o">=&gt;</span> <span class="n">criteria</span><span class="o">[</span><span class="ss">:limit</span><span class="o">]</span><span class="p">}</span>
    <span class="p">)</span><span class="o">.</span><span class="n">each</span><span class="p">(</span><span class="o">&amp;</span><span class="n">block</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1397738/a1a25404469dcce8c1b5de36b0ab48349ca77d84">https://gist.github.com/1397738/a1a254…</a></span>
<p>And now, finally, our query works (don’t forget to add some user documents to your database):</p>
<div class="highlight">
<pre><code class="irb"><span class="go">ruby-1.9.3-p0 :001 &gt; require File.expand_path 'user'</span>
<span class="go"> =&gt; true</span>
<span class="go">ruby-1.9.3-p0 :002 &gt; User.where(:name =&gt; 'Jeff').limit(2).each { |u| puts u.inspect }</span>
<span class="go">{"_id"=&gt;BSON::ObjectId('4ed2603b368ff6d6bc000001'), "name"=&gt;"Jeff"}</span>
<span class="go">{"_id"=&gt;BSON::ObjectId('4ed2603b368ff6d6bc000002'), "name"=&gt;"Jeff"}</span>
<span class="go"> =&gt; nil</span>
</code></pre>
</div>
<h3 id="awesome_now_what">Awesome! Now what?</h3>

<p>Now you have a library that can do chained and lazy-evaluated queries on a MongoDB database. Of course, there’s a lot of stuff you could still add – for example, you could mix in <a href="http://www.ruby-doc.org/core-1.9.3/Enumerable.html">Enumerable</a> and do some metaprogramming magic to remove some of the duplication – but that’s beyond the scope of this article.</p>

<p>If you have any questions, ideas, suggestions or comments, or you just want more articles like this one be sure to let me know in the comments.</p>