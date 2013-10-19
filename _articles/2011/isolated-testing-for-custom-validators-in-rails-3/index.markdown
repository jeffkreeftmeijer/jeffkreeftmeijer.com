<p>It&#8217;s <a href="http://www.talklikeapirate.com/">International Talk Like A Pirate Day</a> today, so you might want to add a custom validation to check if comments submitted in your application actually sound like they were written by a pirate. Right? Right. I thought so. Anyway, let&#8217;s create a validator with specs that don&#8217;t need to require the model every time they run, allowing them to be blazingly fast. Or, at least faster than what you did before.</p>

<p><img alt="Pirate" src="http://jeffkreeftmeijer.com/images/pirate.jpg"></p>

<p>Since we care about keeping our test suite nice and fast, we&#8217;ll try not to load the <code>Comment</code> model and anything else we don&#8217;t really need. Instead of throwing the tests for our validator in the <code>Comment</code>&#8217;s model spec, we&#8217;ll create a new one in <code>spec/validators/pirate_validator_spec.rb</code> and put a mock model named <code>Validatable</code> in there to test with:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">Validatable</span>
  <span class="kp">include</span> <span class="ss">ActiveModel</span><span class="p">:</span><span class="ss">:Validations</span>
  <span class="n">validates_with</span> <span class="no">PirateValidator</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/8d730b568c5ad7440e008439d85ccdb98c0b9ea6">https://gist.github.com/1226439/8d730b...</a></span>
<p>Running it right now (yes, without any actual tests) would end us up with a <code>NameError</code>, telling us <code>ActiveModel</code> is uninitialized. We&#8217;ll need to require it:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'active_model'</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/66dc63860e02aee4ea2f4fa9afcf0f94d59737e0">https://gist.github.com/1226439/66dc63...</a></span>
<p>When running it again, we quickly find out the <code>PirateValidator</code> is uninitialized, since we didn&#8217;t create and require it yet. Let&#8217;s put an empty validator in <code>app/validators/pirate_validator.rb</code> (and don&#8217;t forget to require it in the spec):</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">PirateValidator</span> <span class="o">&lt;</span> <span class="ss">ActiveModel</span><span class="p">:</span><span class="ss">:Validator</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/b5a45ce614cf49b8d0f6a6fc8c50b85d5b739290">https://gist.github.com/1226439/b5a45c...</a></span>
<p>Now the spec actually runs without stumbling on any errors, so we can start writing our first test:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">describe</span> <span class="no">PirateValidator</span> <span class="k">do</span>

  <span class="n">subject</span> <span class="p">{</span> <span class="no">Validatable</span><span class="o">.</span><span class="n">new</span> <span class="p">}</span>

  <span class="n">context</span> <span class="s1">'with a comment that sounds like a pirate'</span> <span class="k">do</span>

    <span class="n">before</span> <span class="p">{</span> <span class="n">subject</span><span class="o">.</span><span class="n">stub</span><span class="p">(</span><span class="ss">:comment</span><span class="p">)</span><span class="o">.</span><span class="n">and_return</span><span class="p">(</span><span class="s1">'Ahoy, matey!'</span><span class="p">)</span> <span class="p">}</span>

    <span class="n">it</span> <span class="p">{</span> <span class="n">should</span> <span class="n">be_valid</span> <span class="p">}</span>

  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/be72a980ae6026b4ac7e0d260c416c0a10b66bc9">https://gist.github.com/1226439/be72a9...</a></span>
<p>Running the spec again, we get a <code>NotImplementedError</code>:</p>

<pre><code>NotImplementedError:
  Subclasses must implement a validate(record) method.</code></pre>

<p>Ah, our <code>PirateValidator</code> doesn&#8217;t have a <code>validate</code> method yet, so we&#8217;ll just add an empty one:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">PirateValidator</span> <span class="o">&lt;</span> <span class="ss">ActiveModel</span><span class="p">:</span><span class="ss">:Validator</span>
  <span class="k">def</span> <span class="nf">validate</span><span class="p">(</span><span class="n">document</span><span class="p">)</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/a1c73c4106977410e54fe10e4c09c5f9a26bebd4">https://gist.github.com/1226439/a1c73c...</a></span>
<p>Wait, what? Our first spec passes, since it asserts the <code>Validatable</code> object to be valid and our validator doesn&#8217;t do anything yet. Let&#8217;s add another test to give it some actual functionality:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">context</span> <span class="s1">'with a comment that sounds like a dinosaur'</span> <span class="k">do</span>

  <span class="n">before</span> <span class="p">{</span> <span class="n">subject</span><span class="o">.</span><span class="n">stub</span><span class="p">(</span><span class="ss">:comment</span><span class="p">)</span><span class="o">.</span><span class="n">and_return</span><span class="p">(</span><span class="s1">'ROOOAAAR!'</span><span class="p">)</span> <span class="p">}</span>

  <span class="n">it</span> <span class="p">{</span> <span class="n">should</span> <span class="n">have</span><span class="p">(</span><span class="mi">1</span><span class="p">)</span><span class="o">.</span><span class="n">error_on</span><span class="p">(</span><span class="ss">:comment</span><span class="p">)</span> <span class="p">}</span>

<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/d29923c4a42530e4dc669e0849e1715481954141">https://gist.github.com/1226439/d29923...</a></span>
<p>Which causes another <code>NoMethodError</code>:</p>

<pre><code>NoMethodError:
  undefined method `error_on' for #&lt;Validatable:0x007faa43462ec8&gt;</code></pre>

<p>That&#8217;s because we use <code>should have(1).error_on(:comment)</code> in our spec, and <code>error_on</code> comes with <a href="https://github.com/rspec/rspec-rails">rspec-rails</a> and we haven&#8217;t included that yet. <code>error_on</code> is in <a href="https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/extensions/active_record/base.rb"><code>RSpec::Rails::Extensions</code></a>, so let&#8217;s just require that:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'rspec/rails/extensions'</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/3c5f4b1e539e30ef8b1d423a273ef952c9a70843">https://gist.github.com/1226439/3c5f4b...</a></span>
<p>If we run our tests again, we notice that they&#8217;re quite a bit slower now. We could solve that by not using the <code>error_on</code> method and not requiring <code>RSpec::Rails::Extensions</code>, but I prefer using <code>error_on</code> instead of having to do assertions on the <code>subject.errors</code> array, but that&#8217;s completely up to you.</p>

<p><em>Update</em>: If you don&#8217;t want to load up <code>RSpec::Rails::Extensions</code>, but do want to use <code>error_on</code>, just put <a href="https://gist.github.com/1239170">this validations support file</a> in <code>spec/support/validations.rb</code> and <code>require 'support/validations'</code> instead of <code>rspec/rails/extensions</code>. This is saving me about 2 seconds.</p>

<p>After requiring <code>RSpec::Rails::Extensions</code>, our spec starts running again and fails, because we haven&#8217;t implemented the actual validation yet. So let&#8217;s do that now:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">PirateValidator</span> <span class="o">&lt;</span> <span class="ss">ActiveModel</span><span class="p">:</span><span class="ss">:Validator</span>
  <span class="k">def</span> <span class="nf">validate</span><span class="p">(</span><span class="n">document</span><span class="p">)</span>
    <span class="k">unless</span> <span class="n">document</span><span class="o">.</span><span class="n">comment</span><span class="o">.</span><span class="n">include?</span> <span class="s1">'matey'</span>
      <span class="n">document</span><span class="o">.</span><span class="n">errors</span><span class="o">[</span><span class="ss">:comment</span><span class="o">]</span> <span class="o">&lt;&lt;</span> <span class="s1">'does not sound like a pirate'</span>
    <span class="k">end</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<span class="small"><a href="https://gist.github.com/1226439/7a79aa385ae18b0418e2319383c3481bd9452caa">https://gist.github.com/1226439/7a79aa...</a></span>
<p>And our test passes! We successfully implemented a model validator without actually loading the model in the specs. Now, getting it running in your model is up to you, but that shouldn&#8217;t be more difficult than getting it to run in <code>Validatable</code>.</p>

<p>If you have any questions or suggestions about this approach to test validators, be sure to let me know in the comments.. <em>Matey</em>.</p>