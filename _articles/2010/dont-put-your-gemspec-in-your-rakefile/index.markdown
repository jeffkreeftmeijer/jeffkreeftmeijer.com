<p>Yesterday I wrote <a href="http://jeffkreeftmeijer.com/2010/gitignore-your-gemspec">&#8220;.gitignore your *.gemspec&#8221;</a>, an article about how annoying it is to have your .gemspec in your repository.</p>
<p>Just to be clear; I was <em>not</em> talking about completely removing .gemspecs from gems and I was <em>not</em> talking to people writing their .gemspecs themselves. My previous post was about using <a href="http://github.com/technicalpickles/jeweler">Jeweler</a>. When using Jeweler, you put your gem information in your Rakefile and generate your .gemspec when you need it.</p>
<p>The problem I found with this was people unnecessarily updating the .gemspec file &#8212; it&#8217;s as easy as running <code>rake .gemspec</code> &#8212; in patches, so I suggested to stop putting .gemspecs in gem repositories.</p>
<p>I think I started a discussion.</p>
<p><a href="http://twitter.com/rbates/status/11487541301">@rbates made a comment</a> about five minutes after I posted. Here&#8217;s the deal; <a href="http://gembundler.com">Bundler</a> has the ability bundle a library from its git repository or from a local path by specifying this in your Gemfile:</p>
<div class="highlight">
<pre><code class="ruby"><span class="c1"># from git</span>
<span class="n">gem</span> <span class="s1">'yourgem'</span><span class="p">,</span> <span class="ss">:git</span> <span class="o">=&gt;</span> <span class="s1">'git://github.com/user/yourgem.git'</span>

<span class="c1"># from a local path</span>
<span class="n">gem</span> <span class="s1">'yourgem'</span><span class="p">,</span> <span class="ss">:path</span> <span class="o">=&gt;</span> <span class="s1">'~/code/yourgem.git'</span>
</code></pre>
</div>
<p>If you load a library like this, it <em>does</em> need to have a .gemspec in its code if it has any dependencies, otherwise Bundler will be unable to resolve and include these dependencies in the bundle.</p>
<p><a href="http://twitter.com/joshpeek/statuses/11489775203">@joshpeek suggests</a> that Jeweler shouldn&#8217;t even have to write a .gemspec file, but <a href="http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended">@wycats eventually wrote a blogpost</a> about adding .gemspecs to your repositories &#8220;as intended&#8221;. Be sure to read it.</p>
<p>I started thinking about other solutions to the initial problem of people updating .gemspecs and wondered; Why are we putting our .gemspecs in our Rakefiles? Is the Rakefile really a place for gem information?</p>
<p>From the replies to my blogpost, a lot of people were just updating their .gemspecs themselves. I opened one of my .gemspec files and didn&#8217;t remember why I had to generate all this.</p>
<p>You don&#8217;t <em>need</em> a tool to generate a .gemspec for you, it&#8217;s as simple as:</p>
<div class="highlight">
<pre><code class="ruby"><span class="ss">Gem</span><span class="p">:</span><span class="ss">:Specification</span><span class="o">.</span><span class="n">new</span> <span class="k">do</span> <span class="o">|</span><span class="n">gem</span><span class="o">|</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">name</span>    <span class="o">=</span> <span class="s1">'yourgem'</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">version</span> <span class="o">=</span> <span class="s1">'0.0.1'</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">date</span>    <span class="o">=</span> <span class="no">Date</span><span class="o">.</span><span class="n">today</span><span class="o">.</span><span class="n">to_s</span>
  
  <span class="n">gem</span><span class="o">.</span><span class="n">summary</span> <span class="o">=</span> <span class="s2">"an awesome gem"</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">description</span> <span class="o">=</span> <span class="s2">"extended description"</span>
  
  <span class="n">gem</span><span class="o">.</span><span class="n">authors</span>  <span class="o">=</span> <span class="o">[</span><span class="s1">'Me Myself'</span><span class="p">,</span> <span class="s1">'One Other'</span><span class="o">]</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">email</span>    <span class="o">=</span> <span class="s1">'me@example.com'</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">homepage</span> <span class="o">=</span> <span class="s1">'http://github.com/user/yourgem'</span>
  
  <span class="c1"># ensure the gem is built out of versioned files</span>
  <span class="n">gem</span><span class="o">.</span><span class="n">files</span> <span class="o">=</span> <span class="no">Dir</span><span class="o">[</span><span class="s1">'Rakefile'</span><span class="p">,</span> <span class="s1">'{bin,lib,man,test,spec}/**/*'</span><span class="p">,</span>
                  <span class="s1">'README*'</span><span class="p">,</span> <span class="s1">'LICENSE*'</span><span class="o">]</span> <span class="o">&amp;</span> <span class="sb">`git ls-files -z`</span><span class="o">.</span><span class="n">split</span><span class="p">(</span><span class="s2">"</span><span class="se">\0</span><span class="s2">"</span><span class="p">)</span>
<span class="k">end</span>
</code></pre>
</div>
<p>If you&#8217;re extremely lazy, check out <a href="http://gist.github.com/356455">@mislav&#8217;s TextMate snippet</a> that generates a new gemspec just by typing <code>gemspec</code>.</p>
<p>The file is easy to read and easy to update. To release a gem, do:</p>
<pre>
$ gem build gem.gemspec
$ gem push gem-0.0.1.gem
</pre>
<p>This solves the issue of having your gem information in your repository twice &#8212; in your Rakefile and in your .gemspec &#8212; and will probably keep people from updating it unintentionally when patching your gem.</p>
<p>So, In my previous article I didn&#8217;t consider installing gems from git or a local path. Right now, you <em>do</em> need your .gemspec in your repository when you want your users to be able to do that.</p>