<p>This week I want to take the time to tell you what <a href="http://git-scm.com/">Git</a>&#8217;s <a href="http://www.kernel.org/pub/software/scm/git/docs/git-reflog.html">reflog</a> and <a href="http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html">bisect</a> commands do and give you a use-case for both so you know when you can actually <em>use</em> them.</p>
<p>This might be old news for you, but I&#8217;ve come across people that use Git but never heard of both or are afraid to use them because they&#8217;re scary. In fact, they&#8217;re not scary. They have the ability to save your ass and make you find bugs faster. Isn&#8217;t that <em>Awesome</em>?</p>
<p><img src="http://jeffkreeftmeijer.com/images/awesome.jpg" title="Awesome robot dinosaurs" alt="Awesome robot dinosaurs"></p>
<h3>The mighty reflog</h3>
<p>You just did a <code>git reset</code> that put you a couple of commits back or you just rebased your whole repository into one commit (don&#8217;t do that) and you realize you didn&#8217;t really want that.</p>
<p>You probably knew you can reset commits, but did you know you can do that &#8212; and more &#8212; on a lot of <em>actions</em> (like merges, pulls and rebases) as well? Simply use <code>git reflog</code> to get an overview of the last actions you did:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git reflog
<span class="go">0db8285 HEAD@{0}: HEAD~5: updating HEAD</span>
<span class="go">177762a HEAD@{1}: commit: change affiliate field names</span>
<span class="go">bb5d920 HEAD@{2}: pull origin develop: Merge made by recursive.</span>
<span class="go">f6fade5 HEAD@{3}: commit: sort the category brands by name on ...</span>
<span class="go">9309873 HEAD@{4}: checkout: moving from feature/affiliate to develop</span>
<span class="go">92a80c2 HEAD@{5}: checkout: moving from develop to feature/affiliate</span>
</code></pre>
</div>
<p>Because every action in this list has a SHA1 hash, you can use the commands you&#8217;re familiar with. In our example, we want to reset to before we messed up:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git reset 177762a
</code></pre>
</div>
<p>Now you moved back to right before you decided to reset or rebase. It&#8217;s like nothing ever happened.</p>
<h3>The amazing bisect</h3>
<p>Something broke and you found out it worked six commits ago (in the release tagged &#8220;v0.1.24&#8221;) by doing a quick <code>git checkout v0.1.24</code> and running your tests. However, you don&#8217;t know which commit introduced the bug, but you want to find out what changed, who did it and if you can revert it quickly.</p>
<p>A really quick way to do something like this is to use <code>git bisect</code>. After starting, you have to specify a &#8220;good&#8221; commit and a &#8220;bad&#8221; one. In this case you know the commit tagged &#8220;v0.1.24&#8221; worked and the &#8220;develop&#8221; branch is broken:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git bisect start
<span class="gp">$</span> git bisect good v0.1.24
<span class="gp">$</span> git bisect bad develop
<span class="go">Bisecting: 2 revisions left to test after this (roughly 1 step)</span>
<span class="go">[5dec197fedabd9db02cc1621f5bbdb2e8defeb48] Merge branch hotfix/...</span>
</code></pre>
</div>
<p>What happened? Well, you switched off your development branch and <code>git bisect</code> took you back three commits so you&#8217;re at the one in the middle between the &#8220;good&#8221; and the &#8220;bad&#8221; one.</p>
<p>Next, run your tests and see if the bug was in this commit already. Let&#8217;s say it was, so you mark this commit &#8220;bad&#8221; as well:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git bisect bad
<span class="go">Bisecting: 0 revisions left to test after this (roughly 0 steps)</span>
<span class="go">[9dea486b10f14475beb56e9d67c6dd45c8fab088] sort the category ...</span>
</code></pre>
</div>
<p>You&#8217;re taken to the next commit to test and you find out it worked in this one, so you mark it &#8220;good&#8221; and Git will tell you the commit that broke stuff:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git bisect good
<span class="go">154f34cd41619eaace63122480c8aa7180f7dbe6 is the first bad commit</span>
<span class="go">commit 154f34cd41619eaace63122480c8aa7180f7dbe6</span>
<span class="go">Author: Thijs Cadier</span>
<span class="go">Date:   Sat Aug 28 19:20:40 2010 +0200</span>

<span class="go">    An editor can publish a photo</span>
</code></pre>
</div>
<p>Now we know which commit introduced the bug, so you can use <code>git show</code> to see what changed and fix it &#8212; or maybe even use <code>git revert</code> &#8212; right away. Did you do this manually before? I did and I can tell you bisecting is a <em>lot</em> faster.</p>
<h3>Want more?</h3>
<p>These are all use-cases that I&#8217;ve run into, but the commands I talked about have a lot more cool features you might want to check out. Two good places to start would be <a href="http://gitready.com">Git Ready</a> by <a href="http://twitter.com/qrush" title="Nick Quaranto">@qrush</a> and <a href="http://book.git-scm.com/">the Git Community Book</a>, since they explain stuff like <a href="http://gitready.com/intermediate/2009/02/09/reflog-your-safety-net.html">reflogging</a> and <a href="http://book.git-scm.com/5_finding_issues_-_git_bisect.html">bisecting</a> more thoroughly.</p>