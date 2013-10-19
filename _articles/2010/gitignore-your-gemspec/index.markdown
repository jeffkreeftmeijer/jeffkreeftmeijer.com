<p>I read <a href="http://twitter.com/pengwynn/status/11321765532">@pengwynn&#8217;s tweet</a> asking people to stop touching his gemspec and I totally agreed, it&#8217;s pretty annoying that people keep sending patches for your gems with updated gemspecs, right? Updating the gemspec is the gem owners job. Stop it.</p>
<p>It didn&#8217;t occur to me until I read <a href="http://twitter.com/qrush/status/11323012967">@qrush&#8217;s response</a>.</p>
<p>In the past, we had to push gemspecs to our repos to make github build gems. Newsflash; <a href="http://gems.github.com">Github stopped doing that</a>.</p>
<p>Right now you&#8217;re probably using <a href="http://github.com/technicalpickles/jeweler">Jeweler</a> to quickly generate a gemspec and release your gem.</p>
<p>So, why are you pushing your gemspec to your repo? The only time you ever need one is when installing your gem locally or releasing it. You always generate a new gemspec when you do that, right? That&#8217;s my point.</p>
<p>Still, lots of people &#8212; even the cool kids &#8212; can&#8217;t kill their old habits. Lets get overly dramatic about this and try to stop this madness. Add this to your <code>.gitignore</code> file;</p>
<pre><code>*.gemspec</code></pre>
<p>Then, <code>rm [yourgem].gemspec</code> from your repo and tell all your friends to read this post and do the same. Let&#8217;s do this. Who&#8217;s with me?</p>
<div class="notice">
This post has a follow-up. Be sure to read <a href="http://jeffkreeftmeijer.com/2010/dont-put-your-gemspec-in-your-rakefile">&#8220;Don&#8217;t put your *.gemspec in your Rakefile&#8221;</a> too.
</div>