<p>Well over a year ago, I wrote about <a href="http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/">using relative line numbers in Vim</a> to speed up movement by displaying line numbers relative to the current line. This makes it easier to find out how many lines up or down you have to jump to get to where you want to be.</p>

<p>Because I wanted to switch back to absolute line numbers when I wasn&#8217;t busy moving around files, I wrote a small vim plugin to do so and released it as <a href="https://github.com/jeffkreeftmeijer/vim-numbertoggle">vim-numbertoggle</a>. This allowed me, and a lot of other people, to use relative numbers when it made sense, and switch back to the default when it didn&#8217;t.</p>

<p>Since Vim 7.4, you can enable both the <code>number</code> and <code>relativenumer</code> settings at the same time, which will give you something I&#8217;ll call hybrid line number mode. Using that, all lines will show their relative line number, except for the line you&#8217;re currently on, which will show its absolute line number.</p>

<p><img alt="The New hybrid line number mode in Vim 7.4" src="http://jeffkreeftmeijer.com/images/hybridnumber.png"><span class="small">Hybrid line number mode in Vim 7.4</span></p>

<p>Setting up Vim to use hybrid mode is easy. All you have to do is enable both the <code>number</code> and <code>relativenumber</code> settings in your config file;</p>
<div class="highlight">
<pre><code class="vim"><span class="k">set</span> <span class="nb">relativenumber</span> 
<span class="k">set</span> <span class="k">number</span>          
</code></pre>
</div>
<p>I wrote the vim-numbertoggle plugin to switch between relative and absolute line numbers because I couldn&#8217;t display them both at the same time. The next best thing was to show relative numbers in normal mode &#8212;because that&#8217;s the mode you use to move around&#8212; and absolute line numbers in insert mode, or when the editor loses focus.</p>

<p>Vim&#8217;s hybrid mode isn&#8217;t exactly the same as what vim-numbertoggle did, but I believe it&#8217;s the most ideal solution right now, so I&#8217;m switching to it. This means I won&#8217;t be able to maintain vim-numbertoggle, since I won&#8217;t be using it anymore.</p>

<p>However, as of yesterday, the plugin has been updated to work nicely with Vim 7.4, so you can keep using it like you did before. I do want to urge you to check out hybrid number mode, though, because it&#8217;s probably better than what I came up with.</p>