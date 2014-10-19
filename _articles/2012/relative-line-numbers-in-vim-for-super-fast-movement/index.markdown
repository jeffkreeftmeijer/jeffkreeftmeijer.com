<p>Vim’s <code>relativenumber</code> is a great setting to help you move around files quickly, but sometimes it can get into your way a bit. Luckily, it’s really easy to add some clever settings, so Vim knows when to toggle between relative and absolute line numbers.</p>

<p>Moving around is probably the most useful thing to learn when you’re starting to use Vim. A good starting point would be to get <a href="http://twitter.com/#!/tednaleid" title="Ted Naleid">@tednaleid</a>’s <a href="http://naleid.com/blog/2010/10/04/vim-movement-shortcuts-wallpaper">movement shortcuts wallpaper</a>, a great cheat sheet you can use to get familiar with some of the commands.</p>

<p><img alt="Relative line numbers in Vim" src="http://jeffkreeftmeijer.com/images/relativenumber.gif"><span class="small">Relative line numbers in Vim</span></p>

<p>After a while, you’ll be able to move by lines, paragraphs and whole screens. Using <code>gg</code> and <code>G</code>, you can move to the start and end of the file and you can use <code>/</code> and <code>?</code> to quickly find some text. Awesome.</p>

<p>But, what do you do when you know where to go and you need to move five, seven, or thirteen lines down? Maybe you want to delete seven lines. What about that?</p>

<p>Commands like <code>j</code> and <code>k</code> can be prefixed with numbers, so <code>5j</code> will jump down five lines. While that’s pretty cool, chances are you won’t actually do that, since counting lines usually takes longer than pressing <code>j</code> until you’re on the right line, especially when you need to jump more than five lines. The same goes for deleting lines, as you probably switch to visual mode and press <code>j</code> a couple of times instead of counting lines and pressing <code>d7d</code>.</p>

<h3 id="relative_or_absolute">Relative or absolute?</h3>

<p>Since 7.3, Vim has a setting called <code>relativenumber</code> (you can set it up with <code>:set relativenumber</code> or <code>:set rnu</code>), which is a lot like the <code>number</code> setting you’re probably using to have line numbers already. But, instead of showing the absolute line numbers from the top of the file, it shows them relative to the line you’re currently on. That means the line below the current one is marked with 1, as is the line above. Now it’s quite easy to find out how many lines you need to jump up or down.</p>

<p>You can’t use absolute and relative line numbers at the same time, so let’s set something up to quickly switch back to absolute line numbers if we need them. A simple function will do this for us and we’ll use <code>&lt;C-n&gt;</code> (that’s control + n) to call it:</p>
<div class="highlight">
<pre><code class="vim"><span class="k">function</span><span class="p">!</span> NumberToggle<span class="p">()</span>
  <span class="k">if</span><span class="p">(</span>&amp;<span class="nb">relativenumber</span> <span class="p">==</span> <span class="m">1</span><span class="p">)</span>
    <span class="k">set</span> <span class="k">number</span>
  <span class="k">else</span>
    <span class="k">set</span> <span class="nb">relativenumber</span>
  <span class="k">endif</span>
endfunc

<span class="nb">nnoremap</span> <span class="p">&lt;</span>C<span class="p">-</span><span class="k">n</span><span class="p">&gt;</span> :<span class="k">call</span> NumberToggle<span class="p">()&lt;</span><span class="k">cr</span><span class="p">&gt;</span>
</code></pre>
</div>
<h3 id="sometimes_you_need_absolute_line_numbers">Sometimes you need absolute line numbers</h3>

<p>Relative line numbers are only useful when moving, so there are a couple of situations where you’d probably want to switch back. Something I ran into was running tests.</p>

<p>Most testing libraries allow you to run a subset of tests based on their line number by running something like <code>rspec spec/models/user_spec.rb:15</code>. Whenever I’d switch to my terminal window to run a single test, I looked back at Vim to see which exact line number I needed to run. Because my line numbers were in relative mode, I needed to switch back to Vim, press <code>&lt;C-n&gt;</code> to get the absolute line numbers again, and then switch back to my terminal to actually run the spec.</p>

<p>A quick solution is to automatically switch to absolute line numbers whenever Vim loses focus, since we don’t really care about the relative line numbers unless we’re moving around:</p>
<div class="highlight">
<pre><code class="vim"><span class="p">:</span><span class="k">au</span> <span class="nb">FocusLost</span> * :<span class="k">set</span> <span class="k">number</span>
<span class="p">:</span><span class="k">au</span> <span class="nb">FocusGained</span> * :<span class="k">set</span> <span class="nb">relativenumber</span>
</code></pre>
</div>
<p>There, now we only have relative numbers when we’re in Vim. But there are more cases when we probably prefer absolute line numbers. In insert mode, for example.</p>

<p>I <a href="https://github.com/jeffkreeftmeijer/dotfiles/blob/master/home/.vim/config/hjkl.vim">disabled my arrow keys in insert mode</a>, to force myself to use <code>5j</code> in normal mode instead of just pressing <code>↓↓↓↓↓</code>. I never move around in insert mode, so relative numbers would be useless and I would probably prefer absolute line numbers. Let’s tell Vim to automatically use absolute line numbers when we’re in insert mode and relative numbers when we’re in normal mode:</p>
<div class="highlight">
<pre><code class="vim">autocmd <span class="nb">InsertEnter</span> * :<span class="k">set</span> <span class="k">number</span>
autocmd <span class="nb">InsertLeave</span> * :<span class="k">set</span> <span class="nb">relativenumber</span>
</code></pre>
</div>
<p>There. Now your line numbers are absolute by default, unless you’re moving around in normal mode. This allows you to use the full power of relative line numbers, without them getting in your way.</p>

<p>Because you’re so special to me, I’ve put the function and autocommands we talked about into a <a href="https://github.com/jeffkreeftmeijer/vim-numbertoggle">plugin</a>, so you can install it easily.</p>

<p>Also, I’d love to know how these settings (or the whole plugin) work for you, so be sure to let me know in the comments or in the <a href="https://github.com/jeffkreeftmeijer/vim-numbertoggle/issues">plugin’s issue tracker</a>.</p>
