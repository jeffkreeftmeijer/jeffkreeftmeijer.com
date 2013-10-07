<p>Remember the last time you wanted to create, update, save or destroy a record or document and your <code>before_create</code> or <code>after_update</code> fired when you didn&#8217;t want it to? Or are you using <a href="http://mongoid.org">Mongoid</a> and did you include <code>Mongoid::Timestamps</code> but don&#8217;t want your <code>updated_at</code> attribute to change for a specific action?</p>
<p>Think for a second. Adding callbacks to disable them later is nasty and will result in code that&#8217;s more difficult to maintain. You probably made a wrong design decision here, so get back to the drawing board and rethink this part of your application if you can.</p>
<p>If you can&#8217;t or you&#8217;re completely sure you have a valid reason to skip your callbacks, you probably tried something like <a href="http://intridea.com/2009/3/12/temporarily-disable-activerecord-callbacks">removing the callback method</a> but found out that didn&#8217;t work anymore.</p>
<p>The way callbacks are handled completely changed in Rails 3, breaking approaches like above. The new <a href="http://apidock.com/rails/ActiveSupport/Callbacks/ClassMethods/skip_callback"><code>skip_callback</code></a> and <a href="http://apidock.com/rails/ActiveSupport/Callbacks/ClassMethods/set_callback"><code>set_callback</code></a> can be of some help though:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">User</span>
  <span class="c1"># I'm using Mongoid, but this should work for anything based on</span>
  <span class="c1"># ActiveModel.</span>
  <span class="kp">include</span> <span class="ss">Mongoid</span><span class="p">:</span><span class="ss">:Document</span>
  <span class="kp">include</span> <span class="ss">Mongoid</span><span class="p">:</span><span class="ss">:Timestamps</span>

  <span class="k">def</span> <span class="nf">sneaky_update</span><span class="p">(</span><span class="n">attributes</span><span class="p">)</span>
    <span class="no">User</span><span class="o">.</span><span class="n">skip_callback</span><span class="p">(</span><span class="ss">:save</span><span class="p">,</span> <span class="ss">:before</span><span class="p">,</span> <span class="ss">:set_updated_at</span><span class="p">)</span>
    <span class="no">User</span><span class="o">.</span><span class="n">update_attributes</span><span class="p">(</span><span class="n">attributes</span><span class="p">)</span>
    <span class="no">User</span><span class="o">.</span><span class="n">set_callback</span><span class="p">(</span><span class="ss">:save</span><span class="p">,</span> <span class="ss">:before</span><span class="p">,</span> <span class="ss">:set_updated_at</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>This will keep <code>Mongoid::Timestamps</code> from calling <code>set_updated_at</code> before saving the Document.</p>
<p>Because I didn&#8217;t like how this looked, I added a method called <code>without_callback</code> to <code>ActiveSupport::Callbacks</code> to allow you to temporarily disable callbacks in a block. Just throw this in <code>config/initializers/without_callback.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">module</span> <span class="nn">ActiveSupport::Callbacks::ClassMethods</span>
  <span class="k">def</span> <span class="nf">without_callback</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">,</span> <span class="o">&amp;</span><span class="n">block</span><span class="p">)</span>
    <span class="n">skip_callback</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
    <span class="k">yield</span>
    <span class="n">set_callback</span><span class="p">(</span><span class="o">*</span><span class="n">args</span><span class="p">)</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>And you&#8217;ll be able to do stuff like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">User</span>
  <span class="c1"># I'm using Mongoid, but this should work for anything based on</span>
  <span class="c1"># ActiveModel.</span>
  <span class="kp">include</span> <span class="ss">Mongoid</span><span class="p">:</span><span class="ss">:Document</span>
  <span class="kp">include</span> <span class="ss">Mongoid</span><span class="p">:</span><span class="ss">:Timestamps</span>

  <span class="k">def</span> <span class="nf">sneaky_update</span><span class="p">(</span><span class="n">attributes</span><span class="p">)</span>
    <span class="no">User</span><span class="o">.</span><span class="n">without_callback</span><span class="p">(</span><span class="ss">:save</span><span class="p">,</span> <span class="ss">:before</span><span class="p">,</span> <span class="ss">:set_updated_at</span><span class="p">)</span> <span class="k">do</span>
      <span class="n">update_attributes</span><span class="p">(</span><span class="n">attributes</span><span class="p">)</span>
    <span class="k">end</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>At least, that&#8217;s how I solved it. I&#8217;m not completely sure this is the prettiest way to do something like this. Do you know of a better way? Be sure to let me know in the comments.</p>