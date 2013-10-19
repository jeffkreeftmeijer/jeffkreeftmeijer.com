<p>As you might have noticed, I’ve been spending some time trying to get running test suites with <a href="https://github.com/rspec">RSpec</a> a bit better and faster over the last weeks. This week I looked into RSpec’s formatters.</p>
<p><img src="http://jeffkreeftmeijer.com/images/fuubar.png" alt=""></p>
<p>Aside from the red “F” RSpec will output when a spec fails, there’s no direct feedback that allows you to go fix things immediately. You’ll simply have to wait until your whole suite is done running, or use ^C to interrupt the run. Another thing you can do is use <a href="http://jeffkreeftmeijer.com/2010/making-rspec-stop-operation-immediately-after-failing">the <code>--fail-fast</code> option I wrote about last week</a> or check out <a href="https://github.com/grosser/rspec-instafail">rspec-instafail</a>, which will output the failure details while continuing to run the rest of your specs. Nice.</p>
<p>Besides that, I realized there were more things that could be improved on, like knowing the total number of specs, the number of specs that have run already and maybe even an <span class="caps">ETA</span> or something like that. Also, the big string of dots and "F"’s started to seem unnecessary, there should be a nicer way to display this information.</p>
<p>I checked out RSpec’s formatters and realized it was extremely easy to write one, so I got distracted and wrote <a href="http://gist.github.com/676219">FffuuuFormatter</a>, which makes RSpec print <span class="caps">FFFUUU</span> instead of <span class="caps">FFFFF</span>. Heh.</p>
<h3>Fuubar</h3>
<p>After looking around for a bit, I found an article by <a href="http://twitter.com/nick_evans" title="Nicholas Evans">@nick_evans</a> posted in 2008, in which he tried to fix some of the issues I’m having with a <a href="http://ekenosen.net/nick/devblog/2008/12/better-progress-bar-for-rspec">progress bar formatter</a>. Nick wrote a really nice solution for it using the <a href="http://rubygems.org/gems/progressbar">progressbar gem</a> by <a href="http://twitter.com/peleteiro" title="Jose Peleteiro">@peleteiro</a>.</p>
<p>I decided to continue Nick’s work and got the formatter up to speed with RSpec 2, using rspec-instafail to handle the direct feedback after every failure.  I put the whole thing in a gem and <a href="http://twitter.com/josevalim" title="José Valim">@josevalim</a> came up with the name: <a href="http://github.com/jeffkreeftmeijer/fuubar">Fuubar</a>.</p>
<p>Here’s a <a href="http://vimeo.com/16845253">short video of Fuubar in action</a>:</p>
<p><object width="440" height="350"><br><param name="allowfullscreen" value="true">
<br><param name="allowscriptaccess" value="always">
<br><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=16845253&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=ff9933&amp;fullscreen=1">
<br><embed src="http://vimeo.com/moogaloop.swf?clip_id=16845253&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=ff9933&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="440" height="350"></embed><br></object></p>
<p>Installing Fuubar is easy. Just put it in your <code>Gemfile</code> and run your specs like this from now on:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> rspec --format Fuubar --color spec
</code></pre>
</div>
<p>If you want to use Fuubar as your default formatter, simply put the options in your <code>.rspec</code> file:</p>
<pre><code>--format Fuubar
--color</code></pre>
<p>After doing that you can simply run your specs like you’re used to:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> rspec spec
</code></pre>
</div>
<h3>Fuuture</h3>
<p>As always: Let me know how you like it and be sure to create an <a href="http://github.com/jeffkreeftmeijer/fuubar/issues">issue on Github</a>, send me a <a href="https://github.com/inbox/new/jeffkreeftmeijer">Github message</a> or an <a href="http://jeffkreeftmeijer.com/contact/">email</a> if you have any ideas or run into any issues. Of course you can always fork the project and send me a pull request or a patch via email.</p>
<p>Fuubar only works on RSpec 2 right now, but there’s no reason why it would be impossible to make it compatible with earlier versions. Also, Nick’s original code had some functionality to find slow specs, but I omitted it because I couldn’t really find a nice implementation.</p>
<p>So, there’s still a lot to do but I think this is quite an improvement from the current formatters. Maybe we can even turn this into a patch for RSpec to make Fuubar one of the default formatters. What do you think?</p>