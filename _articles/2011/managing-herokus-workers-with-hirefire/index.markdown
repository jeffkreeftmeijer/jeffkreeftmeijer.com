<p>As you are most certainly already aware, <a href="http://heroku.com/">Heroku</a> is a platform dedicated to hosting Ruby (or Rack) applications. One of the reasons you might consider Heroku is when you:</p>
<ul>
<li>don&#8217;t know how, or don&#8217;t want to provision and manage servers</li>
	<li>don&#8217;t want to spend time on maintaining or fine-tuning servers (and software)</li>
	<li>want to be up and running in minutes, rather than hours or days</li>
</ul>
<p>Heroku also provides add-ons that hook up internal, and 3rd party services with your application automatically!</p>
<p><img src="http://jeffkreeftmeijer.com/images/hirefire.jpg" alt=""></p>
<p>As appealing as it sounds, in the short run you&#8217;ll find yourself spending a lot of money on resources which you would otherwise get a lot cheaper elsewhere, like with <span class="caps">VPS</span> or dedicated hosting.</p>
<p>One of those resources, is the <a href="http://www.heroku.com/pricing#1-24">Heroku Worker</a>.</p>
<p>When you run a large business, generating plenty of income, such things matter less. However, when you have a bunch of small-medium web applications, be it startups, clients or personal sites, it becomes quite expensive early on for applications that don&#8217;t generate (enough) monthly revenue to pay such fees.</p>
<h3>Enter: HireFire &#8211; The Heroku Worker Manager</h3>
<p>A while back I released <a href="https://github.com/meskyanichi/hirefire">HireFire</a>, an open source RubyGem to address this issue. As the title suggests, HireFire monitors and manages your applications on Heroku. It will shut down workers when there aren&#8217;t any jobs, and will then spin up new ones again when jobs get enqueued. This can save you a significant amount of money since workers will no longer run full-time. Not only that, but it&#8217;ll also enable you to process jobs at a higher concurrency because of the ability to automatically scale up and down.</p>
<p>It has been working great, but since the performance and reliability of my open source solution didn&#8217;t quite cut it, due to Heroku&#8217;s platform limitations, I decided to release it as a hosted service. I gave it a nice interface for easily defining how you want to scale your workers. For example, you could configure it to spin up two workers when the queue size hits 15, and four workers when the queue size hits 30, and so forth. This is nice because you can configure it based on how long the average job of your application takes.</p>
<p>If you want to give it a try, head over to <a href="http://hirefireapp.com">HireFire</a> and set up your worker manager. If you have any questions, check out the <a href="http://hirefireapp.tenderapp.com/kb">knowledge base</a> or post a comment below.</p>