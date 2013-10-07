<p>Last week I released <a href="http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/">an article on git-flow</a>, a tool that helps you keep your <a href="http://git-scm.com/">Git</a> repositories organized. Today I&#8217;d like to explain some things that tend to annoy me while working with other people and using Git.</p>
<p>This article possibly won&#8217;t tell you anything you didn&#8217;t know already, but I just wanted to get this out there and tell you some things that I think would make working with Git a bit more enjoyable.</p>
<h3>Write good commit messages</h3>
<p><a href="http://wildbit.com/blog/2008/11/11/the-importance-of-commit-messages/">Commit messages are important</a>. They document the project&#8217;s progress and they&#8217;re a great way to see what has been done in a commit without having to read the code. Also, commit messages make it easy to dive into <code>git log</code> and find that commit you want to review or revert.</p>
<p>Obviously, you should think about your commit message before typing <code>git commit -m '</code>, slamming your hand on your keyboard, adding the last <code>'</code> and pressing return. Yes, people actually do that.</p>
<p>Another thing is trying to be funny in their messages, blaming other people for writing bad code or writing stuff like &#8220;I don&#8217;t know what the hell I was thinking.&#8221;. Newsflash: You&#8217;re not funny, you&#8217;re being an idiot.</p>
<p>Check out <a href="http://whatthecommit.com">whatthecommit.com</a> for more bad examples.</p>
<p>I don&#8217;t want to know how you feel, what you ate, what time it is or who fucked up in the first place. Please tell me what you did and <em>how</em> you did it. Don&#8217;t try to be clever, witty or funny. Document your change as good as you can and nothing else.</p>
<p>&#8220;<a href="http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html">A note about Git commit messages</a>&#8221; by <a href="http://twitter.com/tpope/" title="Tim Pope">@tpope</a> might be a good read if you think you need some guidelines.</p>
<p><a name="commit-all-the-fucking-time"></a></p>
<h3>Commit all the fucking time</h3>
<p>You&#8217;re at work and your client sends you an email saying he wants a couple of small bugs fixed and the header to be blue instead of green. Other than the rest of your clients, he&#8217;s right: these are really small bugs and changing the header&#8217;s color is just a one-line change.</p>
<p>After getting yourself some coffee, you fix the bugs and change the header in about five minutes. You commit everything:</p>
<div class="highlight">
<pre><code class="console"><span class="go">commit 32faa25585e162f82206b8ce791ec098d6e34677</span>
<span class="go">Author: Jeff Kreeftmeijer</span>
<span class="go">Date:   Mon Aug 23 11:27:10 2010 +0200</span>

<span class="go">  Fix some bugs and make the header blue.</span>
</code></pre>
</div>
<p>After some time and some commits, the client calls you and asks you to undo the header&#8217;s background color back to green. What do you do now?</p>
<p>You can&#8217;t <code>git revert 32faa25585e162f82206b8ce791ec098d6e34677</code>, because that will bring back the bugs you fixed in that commit too. You&#8217;ll have to manually check what the original hue of green was and change it back.</p>
<p>Seriously. Just commit one thing at a time. Don&#8217;t wait until you go home, don&#8217;t fix three <em>really</em> simple bugs before committing, commit <em>every single change separately</em>.</p>
<p><a name="rebase-and-amend-to-get-rid-of-oops-commits"></a></p>
<h3>Rebase &amp; &#8212;amend to get rid of &#8220;oops&#8221;-commits</h3>
<p>Let&#8217;s say you wrote this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">started</span>
  <span class="n">update_attributes</span><span class="p">({</span>
    <span class="ss">:started_at</span> <span class="o">=&gt;</span>  <span class="no">Time</span><span class="o">.</span><span class="n">now</span>
  <span class="p">}</span>
<span class="k">end</span>
</code></pre>
</div>
<p>And you committed it:</p>
<div class="highlight">
<pre><code class="console"><span class="go">commit a5d8e964f6ac22809ffcd7d38ec503e36a27e00b</span>
<span class="go">Author: Jeff Kreeftmeijer</span>
<span class="go">Date:   Mon Aug 23 15:11:10 2010 +0200</span>

<span class="go">  Add Task#start to set the started_at attribute to the current time.</span>
</code></pre>
</div>
<p>After you committed, you find out that you missed the closing parenthesis on line four. You quickly fix it and commit the new version:</p>
<div class="highlight">
<pre><code class="console"><span class="go">commit b3ff4620c2accd674427322cd1c10d634ab63d3a</span>
<span class="go">Author: Jeff Kreeftmeijer</span>
<span class="go">Date:   Mon Aug 23 15:14:48 2010 +0200</span>

<span class="go">  Oops! Forgot the closing parenthesis in Task#start.</span>
</code></pre>
</div>
<p>It might happen that the second commit didn&#8217;t fix everything either and you have to commit a fix again. Maybe once more, because it&#8217;s been a long day. You&#8217;d end up with a bunch of commits fixing problems caused by previous commits.</p>
<p>Well, now it works. After a week you don&#8217;t like this method anymore and want to remove it, which should be easy because you committed small chunks, right? No. You can&#8217;t just <code>git revert a5d8e964f6ac22809ffcd7d38ec503e36a27e00b</code>, you&#8217;ll have to revert both separately.</p>
<p>Whenever you find yourself writing &#8220;oops&#8221; because you&#8217;re fixing a mistake you made in the last commit, please <a href="http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html">rebase</a> them into one. Don&#8217;t worry, it sounds harder than it is.</p>
<p>Let&#8217;s stick with the example we used above. We want to squash the last <em>two</em> commits into one:</p>
<pre><code>git rebase -i HEAD~2</code></pre>
<p>A text editor opens and shows you something like this:</p>
<div class="highlight">
<pre><code class="console"><span class="go">pick a5d8e96 Add Task#start to set the started_at attribute to the current time.</span>
<span class="go">pick b3ff462 Oops! Forgot the closing parenthesis in Task#start.</span>

<span class="gp">#</span> Rebase a5d8e96..b3ff462 onto a5d8e96
<span class="gp">#</span>
<span class="gp">#</span> Commands:
<span class="gp">#</span>  p, <span class="nv">pick</span> <span class="o">=</span> use commit
<span class="gp">#</span>  r, <span class="nv">reword</span> <span class="o">=</span> use commit, but edit the commit message
<span class="gp">#</span>  e, <span class="nv">edit</span> <span class="o">=</span> use commit, but stop <span class="k">for </span>amending
<span class="gp">#</span>  s, <span class="nv">squash</span> <span class="o">=</span> use commit, but meld into previous commit
<span class="gp">#</span>  f, <span class="nv">fixup</span> <span class="o">=</span> like <span class="s2">"squash"</span>, but discard this commit<span class="err">'</span>s log message
<span class="gp">#</span>
<span class="gp">#</span> If you remove a line here THAT COMMIT WILL BE LOST.
<span class="gp">#</span> However, <span class="k">if </span>you remove everything, the rebase will be aborted.
<span class="gp">#</span>
</code></pre>
</div>
<p>If you replace the second occurrence of &#8220;pick&#8221; with &#8220;squash&#8221; and save, another text editor pops up asking you to write a new commit message. After you saved that one, your commits will be merged into one, making your repository cleaner and allowing you to <code>git revert</code> the whole thing at once.</p>
<p>If you want more information about rebasing, be sure to read &#8220;<a href="http://www.gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html">Squashing commits with Rebase</a>&#8221; on <a href="http://www.gitready.com">Git Ready</a>.</p>
<p>If the commit you want to squash into is the last commit, you can even directly add new changes to it by using the <code>--amend</code> flag when committing:</p>
<div class="highlight">
<pre><code class="console"><span class="go">  git commit --amend</span>
</code></pre>
</div>
<h3>I&#8217;m not perfect either</h3>
<p>Before you start digging through my repositories: I&#8217;ve learned a lot in the last couple of months and I&#8217;m improving, but I&#8217;m not perfect either. I&#8217;d love to learn what you do to keep your Git repositories maintainable, so be sure to put your best tip in the comments.</p>