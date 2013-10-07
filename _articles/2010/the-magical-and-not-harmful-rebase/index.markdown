<p>About a month ago, I published a series of articles on <a href="http://git-scm.org">Git</a>, starting with <a href="http://twitter.com/nvie" title="Vincent Driessen">@nvie</a>&#8217;s awesome <a href="http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow">git-flow</a> and <a href="http://jeffkreeftmeijer.com/2010/git-your-act-together">asking you to write better commit messages</a>. The series ended with an article named &#8220;<a href="http://jeffkreeftmeijer.com/2010/the-mighty-reflog-and-the-amazing-bisect">The mighty reflog and the amazing bisect</a>&#8221;. Guess what? I forgot the magical <a href="http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html">rebase</a>.</p>
<p>In general people seem to know rebase as <a href="http://jeffkreeftmeijer.com/2010/git-your-act-together#rebase-and-amend-to-get-rid-of-oops-commits">a tool to squash commits</a>, but that&#8217;s not its general purpose. As the name implies, it can be used to rebase your changes. Oh, and forget about <a href="http://changelog.complete.org/archives/586-rebase-considered-harmful">that article that made you scared of rebase</a>, nothing bad will happen if you know what you&#8217;re doing.</p>
<p>Let&#8217;s say you&#8217;re working on a feature branch called <code>feature/login</code> and somebody else implemented something and pushed it to the <code>develop</code> branch. You need that change. What do you do?</p>
<p><img src="http://jeffkreeftmeijer.com/images/rebase01.jpg" title="You need that change. What do you do?" alt="You need that change. What do you do?"></p>
<p>You <em>could</em> simply <a href="http://www.kernel.org/pub/software/scm/git/docs/git-merge.html">merge</a> that into your feature branch, but that would result in one of those nasty merge commits:</p>
<p><img src="http://jeffkreeftmeijer.com/images/rebase02.jpg" title="You could simply merge that into your feature branch, but that would result in one of those nasty merge commits" alt="You could simply merge that into your feature branch, but that would result in one of those nasty merge commits"></p>
<p>Another option is to <a href="http://www.kernel.org/pub/software/scm/git/docs/git-cherry-pick.html">cherry-pick</a> the change you need into your branch. While &#8212; history wise &#8212; I don&#8217;t see a real problem with this, it&#8217;s a bit of a hassle because you need to find the commit you need to merge in first.</p>
<p>Git&#8217;s <a href="http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html">Rebase</a> allows you to temporarily rewind the commits you did in this branch, pull in everything from another branch and apply your commits on top of that again:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git rebase develop
<span class="go">First, rewinding head to replay your work on top of it...</span>
<span class="go">Fast-forwarded feature/login to develop.</span>
</code></pre>
</div>
<p><img src="http://jeffkreeftmeijer.com/images/rebase03.jpg" title="Git's rebase allows you to temporarily rewind the commits you did in this branch, pull in everything from another branch and apply your commits on top of that again" alt="Git's rebase allows you to temporarily rewind the commits you did in this branch, pull in everything from another branch and apply your commits on top of that again"></p>
<p>It&#8217;s as if you didn&#8217;t start working in the <code>feature/login</code> branch before the commits you pulled in were made. Nice, huh? You can also <a href="http://www.gitready.com/advanced/2009/02/11/pull-with-rebase.html">pull with rebase</a> so you don&#8217;t have to switch out of your current branch.</p>
<h3>Conflicts served in smaller chunks</h3>
<p>Besides keeping your history clean, rebase also has your back when you run into a merge conflict during the rebase:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git rebase develop
<span class="go">First, rewinding head to replay your work on top of it...</span>
<span class="go">Applying: feature/login</span>
<span class="go">Using index info to reconstruct a base tree...</span>
<span class="go">Falling back to patching base and 3-way merge...</span>
<span class="go">Auto-merging config/environment.rb</span>
<span class="go">CONFLICT (content): Merge conflict in config/environment.rb</span>
<span class="go">Failed to merge in the changes.</span>
<span class="go">Patch failed at 0001 feature/login</span>

<span class="go">When you have resolved this problem run "git rebase --continue".</span>
<span class="go">If you would prefer to skip this patch, instead run "git rebase --skip".</span>
<span class="go">To restore the original branch and stop rebasing run "git rebase --abort".</span>
</code></pre>
</div>
<p>Because rebase merges every commit individually, conflicts will be served in smaller chunks making them easier to fix and understand. When you&#8217;re done fixing a conflict, simply <code>git add</code> the file and continue rebasing:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> git rebase --continue
</code></pre>
</div>
<h3>Rebase vs Merge</h3>
<p>When you&#8217;re working on a feature branch and you need changes from the main development branch, I would suggest using rebase. Merge can be used when you want to merge a feature branch back into your development branch. That way, you&#8217;ll be able to see when you merged in what in the future because you have that merge commit I called &#8220;nasty&#8221; before. It isn&#8217;t, really.</p>
<p>What I would like to ask you is to rebase your feature branch to the main development branch before merging it in. This way you make sure your branch applies cleanly to the branch you&#8217;re merging into.</p>
<p>Do you use rebase? When do you choose rebase over merge? Do you <a href="http://darwinweb.net/articles/the-case-for-git-rebase">rebase exclusively</a>? Are you still <a href="http://changelog.complete.org/archives/586-rebase-considered-harmful">scared of rebase</a>? Let me know in the comments.</p>