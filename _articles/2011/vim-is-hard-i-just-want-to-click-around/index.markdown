<p>More than a year ago, I wrote about <a href="http://jeffkreeftmeijer.com/2010/stumbling-into-vim/">switching to Vim</a>. I was quite happy with how it all worked, but I found myself switching back to Textmate after a while. I read through a lot of dotfiles to “steal” some configuration options from others, took some time to go through <code>vimtutor</code>, read some blogposts and after a while, I was quite happy with how it all worked.</p>

<p><img alt="Alloys MacVim fork with Janus" src="http://jeffkreeftmeijer.com/images/vim2.png"><span class="small">My new, full screen Janus-powered MacVim editor, with sexy drawer</span></p>

<p>But after some time, I started switching back to Textmate. At first, I only opened it up to do non-code writing, but after a while, I started using Textmate for bigger projects too since it felt easier to navigate around project files. After about half a year, I was back to Textmate completely and I only used Vim on my Ubuntu-powered netbook sometimes.</p>

<p>Sometimes, I just want to click around, especially when looking for and opening files. I missed Textmate’s drawer and never really got the hang of the NERDTree plugin I was using. Besides that, my Vim config felt incomplete, but I didn’t know exactly what I was missing or what I needed to install to make everything easier. While I loved editing code in Vim, I couldn’t really get used to the rest of the editor.</p>

<h3 id="macvim">MacVim</h3>

<p>It turns out I wasn’t the only one running into problems like this. Less than five kilometers from where I was switching back, <a href="http://twitter.com/alloy" title="Eloy Durán">@alloy</a> decided to fix the problem instead of running back to Textmate. He created <a href="https://github.com/alloy/macvim">his own fork of MacVim</a> and added a Textmate-like file drawer.</p>

<p>I got a new hard drive, which was a great excuse to do a clean install and set up a better work environment. I started out by installing Eloy’s MacVim branch, and quickly found out the drawer works as good – or even better – as Textmate’s.</p>

<p>The one thing I didn’t really like was the new native Lion fullscreen mode, which newer versions of MacVim use by default. Its animations annoyed me and when using multiple screens, it cleared out the second screen when I put something in fullscreen mode on the first one. In my earlier attempt at using MacVim, they rolled their own fullscreen mode that worked perfectly and I wanted that back.</p>

<p>Luckily, that’s pretty easy to achieve. It’s a matter of throwing this into your terminal:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> defaults write org.vim.MacVim MMNativeFullScreen 0
</code></pre>
</div>
<p>If that doesn’t work for you, update MacVim. I had some problems getting it to work, having a slightly older version.</p>

<h3 id="janus">Janus</h3>

<p>Instead of going around stealing configurations from other people’s dotfiles again, I installed <a href="https://github.com/carlhuda/janus">Janus</a>. Janus is an awesome Vim config by <a href="http://twitter.com/wycats" title="Yehuda Katz">@wycats</a> and <a href="http://twitter.com/carllerche" title="Carl Lerche">@carllerche</a>, which comes with a bunch of great plugins and color schemes and it probably has everything you need.</p>

<p>It installs NERDTree by default, which I don’t need because I already have a file drawer. It’s really easy to skip it, though. Before running <code>rake</code> in your <code>~/.vim</code> directory, create a file named <code>~/.janus.rake</code> and put this in:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">skip_vim_plugin</span> <span class="s2">"nerdtree"</span>
</code></pre>
</div>
<p>If you already installed before (with NERDTree enabled), be sure to delete the <code>~/.vim/nerdtree</code> directory.</p>

<p>Without NERDTree, I started getting some error messages when changing directories inside MacVim:</p>

<pre><code>Error detected while processing function ChangeDirectory:
line    4:
E492: Not an editor command:   NERDTree</code></pre>

<p>So, after looking around for a bit, I found the problem in <code>~/.vim/gvimrc</code>. In the <code>ChangeDirectory</code> function, I removed <a href="https://github.com/carlhuda/janus/blob/master/gvimrc#L172">line 172</a> and the problem disappeared. I haven’t had time to turn this into a patch, sorry.</p>

<p>Oh, and while Janus comes with a plugin that highlights trailing whitespace, it doesn’t automatically clear it when you save. I put this in my <code>~/.vimrc.local</code> file to never have to worry about that again:</p>

<pre><code>autocmd BufWritePre * :%s/\s\+$//e</code></pre>

<h3 id="click_click">Click, click?</h3>

<p>What I found amazing is how fast I started to get used to switching files without clicking and using the drawer. Janus installed Command-T and I started to use that most of the time. It can even open files in new tabs by pressing <code>^+T</code> instead of Enter after selecting the file you need. Right now, I’m keeping the drawer closed by default and I’m using<code> ⌘+⇧+D</code> to pop it out whenever I need it.</p>

<p>Like last time, I still have a lot to learn – both about Vim itself and the plugins I have installed – but I think my setup is pretty good now. Have any great tips to make this even better? Let me know in the comments!</p>