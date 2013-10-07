<p class="small">
<strong>Note:</strong> I stopped working at <a href="http://80beans.com">80beans</a>, so I can&#8217;t help you with any issues anymore. You can always send an e-mail to <a href="mailto:help@tapirgo.com">Tapir&#8217;s support e-mail address</a> if you need help, though.
</p>
<p>Static site generators like <a href="https://github.com/mojombo/jekyll">Jekyll</a> allow you to generate your whole website or blog as static <span class="caps">HTML</span> files and put it online without having to use a database or even building an actual application.</p>
<p>While being static has a lot of advantages, it can be quite a pain in some situations. Since you don&#8217;t have a database, you can&#8217;t build a commenting system so your readers can comment on what you write, for example. Some other things are analytics and contact forms. Luckily, there are really nice solutions &#8212; like <a href="http://discus.com">Disqus</a>, <a href="http://google.com/analytics">Google analytics</a> and <a href="http://wufoo.com">Wufoo</a> &#8212; that allow you to implement these features using a simple javascript snippet.</p>
<p>A feature I really wanted in my website was search, since the <a href="/archive">archive</a> grew quite a bit and it became impossible to find an article without knowing its title, so I started looking for a solution I could use.</p>
<p><a href="http://tapirgo.com"><img src="http://jeffkreeftmeijer.com/images/tapirgo.png" alt=""></a></p>
<p>After <a href="http://twitter.com/#!/jkreeftmeijer/status/62928349399490560">asking around</a>, it turned out <a href="http://www.google.com/cse/">Google&#8217;s custom search</a> is still the most used out there. The problem I ran into was that it takes you off the website you were searching on and takes you to a Google results page (complete with slightly irrelevant ads).</p>
<p>I wanted a more elegant solution, with a nice <span class="caps">JSON</span> <span class="caps">API</span> that would allow me to build a search feature on my website using only javascript, but I found out that most of the existing search engines didn&#8217;t have an <span class="caps">API</span>, made me put their logo on my website or gave me a request limit.</p>
<p>After discussing this at <a href="http://80beans.com">80beans</a>, we decided to get some beers, order dinner and throw something together ourselves. After a couple of hours, we had a working prototype and we asked <a href="http://twitter.com/ivanasetiawan" title="Ivana Setiawan">@ivanasetiawan</a> to draw us an awesome Tapir and create a nice design for the website. We took a week to tweak and test the application before we released it into the wild.</p>
<h3>Tapir, go!</h3>
<p><a href="http://tapirgo.com">Tapir</a> is a simple application that indexes your <span class="caps">RSS</span> feed and uses <a href="https://github.com/karmi/tire">Tire</a> (which is powered by <a href="http://www.elasticsearch.org">Elasticsearch</a>, which is powered by <a href="http://lucene.apache.org">Lucene</a>) to index and search it. It gives you a straightforward <span class="caps">JSON</span> <span class="caps">API</span> that returns the results.</p>
<p>After signing up and getting your token, you&#8217;ll be able to use this <span class="caps">API</span> to search your site. For example, here&#8217;s one of my results when <a href="http://tapirgo.com/api/1/search.json?token=4dbfc79e3f61b05b53000011&amp;query=capybara">searching for &#8220;Capybara&#8221;</a>:</p>
<pre><code>[
  {
      "title":"Capybara ate Swinger",
      "published_on":"2011-02-07T05:00:00Z",
      "content": [the full article content],
      "link":"http://jeffkreeftmeijer.com/2011/capybara-ate-swinger",
      "summary":"Remember Swinger, the Capybara RSpec driver swapper? Capybara can now swap drivers out of the box.",
      "_score":61.15513
    }
  ]</code></pre>
<p>Tapir will check your feed every fifteen minutes to see if there&#8217;s anything new to index, but of course you can also ping it to update your search results immediately.</p>
<p>Using that, you can build your own search feature, which requests its results from Tapir&#8217;s <span class="caps">API</span>. If you want to give it a go, check out <a href="http://jeffkreeftmeijer.com/search/?query=capybara">the one I implemented</a>.</p>
<h3>What&#8217;s next?</h3>
<p>Over the last week we&#8217;ve been busy tweaking the search results and making the application more usable. We have a couple of plans to make Tapir more awesome, but we definitely need your help. If you start using Tapir, have a great idea or if you run into any issues, <a href="http://twitter.com/tapirgo" title="Tapir">@tapirgo</a> would be glad to hear about it or try help you out.</p>
<p>While we built Tapir to search static sites, you can use it for anything that has an <span class="caps">RSS</span> feed, of course. <a href="http://twitter.com/thedjinn" title="Emil Loer">@thedjinn</a> created a <a href="http://emilloer.com/2011/05/04/searching-the-news-with-tapir/">news search</a> that searches multiple feeds, like <span class="caps">CNN</span> and the Dutch <span class="caps">NOS</span>. If you end up doing something awesome we hadn&#8217;t thought about before, be sure to let us know.</p>
<p>Now, what do <em>you</em> think of Tapir?</p>