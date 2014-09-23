<p>In January of this year, <a href="http://twitter.com/nvie" title="Vincent Driessen">@nvie</a> published <a href="http://nvie.com/posts/a-successful-git-branching-model">&#8220;A successful Git branching model&#8221;</a>, in which he explained how he keeps his Git repositories nice and tidy. In addition to that, he released <a href="http://github.com/nvie/gitflow">git-flow</a>; a bunch of Git extensions to make following this model extremely easy.</p>
<p>I&#8217;m astounded that some people never heard of it before, so in this article I&#8217;ll try to tell you why it can make you happy and cheerful all day.</p>
<p><img src="http://jeffkreeftmeijer.com/images/gitflow.png" alt=""></p>
<p>After installing git-flow, you can start a new repository in the current directory or convert an existing one to the new branch structure:</p>
<pre><code>$ git flow init</code></pre>
<p>It will ask you a bunch of questions, but you probably want to accept the default values:</p>
<pre><code>No branches exist yet. Base branches must be created now.
Branch name for production releases: [master] 
Branch name for "next release" development: [develop] 
How to name your supporting branch prefixes?
Feature branches? [feature/] 
Release branches? [release/] 
Hotfix branches? [hotfix/] 
Support branches? [support/] 
Version tag prefix? []</code></pre>
<p>After you&#8217;ve answered the questions, git flow sets your default branch to <code>develop</code> (or whatever you named it) automatically, since that&#8217;s the one you&#8217;ll be working in.</p>
<p>Now, simply use Git like you&#8217;re used to, but only work on some small features in the <code>develop</code> branch. If you need to work on a bigger feature, just create a feature branch based on <code>develop</code>. Let&#8217;s say you want to add a login page:</p>
<pre><code>$ git flow feature start login</code></pre>
<p>This will create a new branch called <code>feature/login</code>, based on our <code>develop</code> branch and switches to it. Commit away and after you finish working on the login page, simply finish it:</p>
<pre><code>$ git flow feature finish login</code></pre>
<p>It&#8217;ll merge <code>feature/login</code> back to <code>develop</code> and delete the feature branch.</p>
<p>When you&#8217;re feature complete, simply start a release branch &#8212; again, based on <code>develop</code> &#8212; to bump the version number and fix the last bugs before releasing:</p>
<pre><code>$ git flow release start v0.1.0</code></pre>
<p>When you finish a release branch, it&#8217;ll merge your changes to <code>master</code> <em>and</em> back to <code>develop</code>, so you don&#8217;t have to worry about your <code>master</code> being ahead of <code>develop</code>.</p>
<p>The last thing that makes git-flow awesome is its ability to handle hotfixes. You start and finish a hotfix branch like anything else, but it&#8217;s based on <code>master</code> so you can quickly fix it when something&#8217;s broken production and merge it back to <code>master</code> and <code>develop</code> using <code>finish</code>.</p>
<p>Awesome, right? Now, why aren't you using git-flow?</p>

