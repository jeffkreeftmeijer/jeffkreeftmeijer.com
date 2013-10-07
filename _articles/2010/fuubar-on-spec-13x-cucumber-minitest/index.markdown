<p>Last week, I released an <a href="http://jeffkreeftmeijer.com/2010/fuubar-the-instafailing-rspec-progress-bar-formatter">RSpec progress bar formatter called Fuubar</a> and some cool stuff has happened since.</p>
<p>Version 0.0.2 was released, which uses <a href="http://rubygems.org/gems/ruby-progressbar">ruby-progessbar</a> instead of <a href="http://rubygems.org/gems/progressbar">progressbar</a> and prints the bar using <code>====</code> instead of <code>oooo</code>. <a href="http://twitter.com/iain_nl" title="Iain Hecker">@iain_nl</a> moved the progress bar <a href="https://github.com/jeffkreeftmeijer/fuubar/issues/closed#issue/2">two spaces to the right</a>, a couple of bugs were squashed and Fuubar is eating its own dog food by using itself as its default formatter now.</p>
<h3>RSpec 1.3.x</h3>
<p>With <a href="https://github.com/jeffkreeftmeijer/fuubar/issues/closed#issue/5">a lot of help</a> from <a href="http://twitter.com/#!/__NeX__" title="Roberto Decurnex">@__NeX__</a>, Fuubar got RSpec 1.3.x support today. It&#8217;s in a separate <a href="https://github.com/jeffkreeftmeijer/fuubar/tree/legacy">legacy branch</a> and it&#8217;s <em>not</em> released as a separate gem right now.</p>
<p>Installing it for RSpec 1.3.x should still be quite easy. Since you need to pull it in from git, you need to specify the repository url and branch name in your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby">  <span class="n">gem</span> <span class="s1">'fuubar'</span><span class="p">,</span> 
    <span class="ss">:git</span> <span class="o">=&gt;</span> <span class="s1">'git://github.com/jeffkreeftmeijer/fuubar.git'</span><span class="p">,</span> 
    <span class="ss">:branch</span> <span class="o">=&gt;</span> <span class="s1">'legacy'</span>
</code></pre>
</div>
<p>If you want to use Fuubar as your default formatter, put this in your <code>spec/spec.opts</code> file:</p>
<pre><code>--format Fuubar
--color</code></pre>
<h3>Cucumber and MiniTest</h3>
<p>A bunch of work has been done to build a <a href="http://gotmayonase.tumblr.com/post/1616925126/minitest-progressbar">Fuubar-like formatter for MiniTest</a> by <a href="http://twitter.com/mike_mayo" title="Mike Mayo">@mike_mayo</a>, who has been building it into <a href="https://github.com/gotmayonase/minitest">his MiniTest fork</a>. Keep an eye on <a href="http://gotmayonase.tumblr.com">his blog</a> for more information about the project.</p>
<p>Also, there&#8217;s a ready-to-use gem called <a href="https://github.com/martinciu/fuubar-cucumber">fuubar-cucumber</a>, released by <a href="http://twitter.com/martinciu" title="Marcin Ciunelis">@martinciu</a>, so you can even use Fuubar when you&#8217;re on <a href="http://cukes.info">Cucumber</a> for acceptance testing.</p>
<p>I&#8217;m excited to see where this is going, Fuubar&#8217;s being used in a couple of <a href="https://github.com/search?type=Code&amp;language=ruby&amp;q=fuubar&amp;repo=&amp;langOverride=&amp;x=0&amp;y=0&amp;start_value=1">projects</a> already (most notably <a href="https://github.com/jnicklas/capybara">Capybara</a> and <a href="https://github.com/tomas-stefano/infinity_test">infinity_test</a>) and nice ideas are popping up. Thanks for helping out, using it and spreading the word, everyone!</p>
<p>Now, what would you like to see in Fuubar in the near future?</p>