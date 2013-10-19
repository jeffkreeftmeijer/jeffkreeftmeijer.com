<p><span class="small"><br><strong>tl;dr</strong> <a href="http://stillmaintained.com" title="Still Maintained?">StillMaintained</a> got a bunch of awesome new features. Be sure to have a look and add your projects!<br></span></p>
<p>Two weeks ago, I <a href="http://jeffkreeftmeijer.com/2010/finally-a-way-to-mark-your-github-project-as-abandoned">launched</a> <a href="http://stillmaintained.com">StillMaintained</a>: a simple application that makes it easy to give your <a href="http://github.com">Github</a> projects a state and create nice status pages for them.</p>
<p>Since then, a bunch of <a href="https://github.com/jeffkreeftmeijer/stillmaintained/issues">issues</a> were created and a lot of work has been done. In this article I&#8217;ll go over some of the coolest new stuff.</p>
<h3>Soon: New design</h3>
<p>Okay, this isn&#8217;t really done yet, but we are too excited about it to keep it a secret. Over the last two weeks, <a href="http://twitter.com/ivanasetiawan" title="Ivana Setiawan">@ivanasetiawan</a> has been doing some awesome work creating a proper design for StillMaintained. Here&#8217;s a quick preview, we&#8217;re doing our best to get it up soon.</p>
<p><a href="http://stillmaintained.com"><img src="http://jeffkreeftmeijer.com/images/stillmaintained_design.jpg" alt=""></a></p>
<h3>Organization support</h3>
<p>Since you can&#8217;t log in as an organization on Github, it was impossible to add any projects that weren&#8217;t started by an actual user when StillMaintained launched.</p>
<p>Using Github&#8217;s <a href="http://develop.github.com/p/orgs.html">Organizations <span class="caps">API</span></a>, StillMaintained got organization support last week.</p>
<p>If you log in via Github now, the projects of the organizations you&#8217;re a member of are editable by you. If you add them to the list, the organization they belong to gets its own page and the project gets a status page like any other.</p>
<p>Did you add your projects already? You can just log in again to update your projects and add projects from organizations you&#8217;re a member of.</p>
<h3>
<span class="caps">JSON</span> <span class="caps">API</span>
</h3>
<p>Thanks to <a href="http://twitter.com/matsimitsu" title="Robert Beekman">@matsimitsu</a>, StillMaintained got a very simple <span class="caps">API</span> allowing you to fetch data in <span class="caps">JSON</span> format:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> curl http://stillmaintained.com/jeffkreeftmeijer/fuubar.json
<span class="go">{"name":"fuubar","created_at":"2010/11/30 07:09:55 +0000","watchers":92,"updated_at":"2010/12/09 21:21:16 +0000","_id":"4cf3c2a6f9d9006a5d00000b","description":"The instafailing RSpec progress bar formatter","visible":true,"user":"jeffkreeftmeijer","state":"maintained"}</span>
</code></pre>
</div>
<p>You can get any page in <span class="caps">JSON</span> by adding <code>.json</code> after the <span class="caps">URL</span>. Be sure to let me know if you create anything awesome with it.</p>
<h3>Status buttons</h3>
<p>To be able to tell your users the state of your project while not on StillMaintained, Robert and I added nice self-updating status buttons you can embed in your project&#8217;s <code>README</code> on Github (or anywhere else you&#8217;d like).</p>
<p><a href="http://stillmaintained.com"><img src="http://jeffkreeftmeijer.com/images/stillmaintained_status_buttons.jpg" alt=""></a></p>
<p>If your project is listed on StillMaintained, you can simply embed the image like this:</p>
<div class="highlight">
<pre><code class="html">  <span class="nt">&lt;a</span> <span class="na">href=</span><span class="s">"http://stillmaintained.com/you/yourproject"</span><span class="nt">&gt;</span>
    <span class="nt">&lt;img</span> <span class="na">src=</span><span class="s">"http://stillmaintained.com/you/yourproject.png"</span> <span class="nt">/&gt;</span>
  <span class="nt">&lt;/a&gt;</span>
</code></pre>
</div>
<p>Oh, and be sure to check out <a href="https://gist.github.com/731135">this Gist</a> for more information.</p>
<h3>And more</h3>
<p>StillMaintained also has search and state filtering, project descriptions and the lists are ordered by project popularity to name a few more. Be sure to <a href="http://stillmaintained.com">check it out</a> and if you have any great ideas: it&#8217;s <a href="http://github.com/jeffkreeftmeijer/stillmaintained">on Github</a>, so be sure to create <a href="http://github.com/jeffkreeftmeijer/stillmaintained/issues">issues</a> or even fork the project and get your hands dirty yourself.</p>
<p>So, what do you think? Do you like the new design and the new features?</p>