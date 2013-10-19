<p class="small">
<strong>Note:</strong> This is just something I've been playing around with. I'm not saying you should do this and I'm not implying this is better than what you're doing right now. I'm just sharing some experiences from a quick experiment.
</p>
<p>For <a href="http://codebrawl.com">Codebrawl</a>, I created a library that could take a method from a model &#8211; like <code>calculate_score</code> for example &#8211; and give it a corresponding bang method &#8211; <code>calculate_score!</code> in this case &#8211; that saves the results using a simple <code>update_attribute</code> call. In your model, I can just do this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">class</span> <span class="nc">User</span>

 <span class="n">bang</span> <span class="ss">:calculate_score</span> <span class="o">=&gt;</span> <span class="ss">:score</span>

 <span class="k">def</span> <span class="nf">calculate_score</span>
   <span class="mi">100</span> <span class="c1"># Removed fancy logic for presentational purposes</span>
 <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>Now, calling <code>calculate_score!</code> will save the results of <code>calculate_score</code> to the score attribute. It&#8217;s one 4-line method in one file and it has a 25-line spec. Simple.</p>

<p><a href="https://gist.github.com/1232884"><img alt="MicroGem" src="http://jeffkreeftmeijer.com/images/microgem.png"></a></p>

<p>After a while, I ran into the same &#8220;issue&#8221; in another project. I wanted to use my new Bang library, but I didn&#8217;t want to copy it over to the new project and I didn&#8217;t feel like starting a new repository on <a href="https://github.com">Github</a> because that would mean I&#8217;d have to write a <code>README</code>, squat a name on <a href="http://rubygems.org">RubyGems</a>, accept issues and support it forever. It just felt too small for that.</p>

<p>Instead, <a href="https://gist.github.com/1232884">I put the library into a Gist</a>. The great thing about Gists is that they&#8217;re full Git repositories in disguise, so I can just clone my library, work on it and push a new &#8220;release&#8221; without having to fiddle around in Gist&#8217;s web interface.</p>

<p>To be able to use it as a RubyGem, the only thing I needed to do was add a very, <em>very</em> simple <a href="https://gist.github.com/1232884#file_bang.gemspec">gemspec</a>. The thing you have to keep in mind is that you can&#8217;t have any directories in Gists (you could, but these files are hidden in the web interface). This means your gemspec will be a bit different from what you normally do. Instead of doing crazy git command magic, you&#8217;ll set your <code>files</code>, <code>test_file</code> and <code>require_path</code> like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">s</span><span class="o">.</span><span class="n">files</span>         <span class="o">=</span> <span class="o">[</span><span class="s1">'bang.rb'</span><span class="o">]</span>
<span class="n">s</span><span class="o">.</span><span class="n">test_file</span>     <span class="o">=</span> <span class="s1">'bang_spec.rb'</span>
<span class="n">s</span><span class="o">.</span><span class="n">require_path</span>  <span class="o">=</span> <span class="s1">'.'</span>
</code></pre>
</div>
<p>Using the power of Bundler, I can now require my library in my projects, without even having to push it to RubyGems:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">gem</span> <span class="s1">'bang'</span><span class="p">,</span> <span class="ss">:git</span> <span class="o">=&gt;</span> <span class="s1">'git://gist.github.com/1232884.git'</span>
</code></pre>
</div>
<h3 id="trying_this_at_home">Trying this at home</h3>

<p>See how easy it is to create your own RubyGem? The only thing you need is an implementation and a gemspec. Since Bang isn&#8217;t much more than that right now, I think a Gist is sufficient. At least for now.</p>

<p>If your project is bigger than this or has any users besides yourself, you&#8217;re probably going to have to create a proper Github repository and push it to RubyGems. Gists don&#8217;t support Github&#8217;s issues, you can&#8217;t accept pull requests and you can&#8217;t use directories. As long as your library doesn&#8217;t need any of that, I think you&#8217;ll be fine with something as simple as this.</p>

<p>I&#8217;ve been using my &#8220;MicroGem&#8221; for a while now and I haven&#8217;t run into any issues yet. Do you foresee problems with this approach or do you have any ideas to make it even better? Please let me know in the comments!</p>