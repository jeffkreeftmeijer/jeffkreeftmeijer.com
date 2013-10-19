<p><a href="http://github.com/achiu/terminitor">Terminitor</a> &#8212; that&#8217;s <em>not</em> Termin<strong>a</strong>tor &#8212; is a really simple Terminal workflow automation tool by <a href="http://twitter.com/arthur_chiu" title="Arthur Chiu">@arthur_chiu</a> and the rest of the <a href="http://www.padrinorb.com/">Padrino</a> <a href="http://www.padrinorb.com/team">team</a>. It aims to automate the terminal commands you do when you start working on a project so you don&#8217;t have to start your database, web server and editor every time you want to continue your work.</p>
<p>After installing, you create a &#8220;terminit&#8221; <span class="caps">YAML</span> file that defines one or more tabs with the commands you want to run. I created a little config for working on my website:</p>
<div class="highlight">
<pre><code class="yaml"><span class="c1"># ~/.terminitor/jeffkreeftmeijer.yml</span>

<span class="p-Indicator">-</span> <span class="l-Scalar-Plain">server</span><span class="p-Indicator">:</span>
  <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">cd ~/opensource/jeffkreeftmeijer.com</span>
  <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">jekyll --server --auto</span>
<span class="p-Indicator">-</span> <span class="l-Scalar-Plain">browser</span><span class="p-Indicator">:</span>
  <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">sleep 5</span>
  <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">open --background http://localhost:4000</span>
<span class="p-Indicator">-</span> <span class="l-Scalar-Plain">vim</span><span class="p-Indicator">:</span>
  <span class="p-Indicator">-</span> <span class="l-Scalar-Plain">mvim ~/opensource/jeffkreeftmeijer.com</span>
</code></pre>
</div>
<p>This will open up three tabs in my terminal. The first one starts the <a href="http://github.com/mojombo/jekyll">Jekyll</a> server, with the <code>--auto</code> flag to make it update after every change automatically. Another tab sleeps for five seconds &#8212; giving the server a bit of time to start &#8212; and opens localhost in a browser window behind the terminal. The last one opens the project in Vim, so I can start writing right away.</p>
<p>To do all of the above, I simply run Terminitor&#8217;s <code>start</code> command:</p>
<pre><code>$ terminitor start jeffkreeftmeijer</code></pre>
<p>Pretty cool, right? Be sure to check out the <a href="http://github.com/achiu/terminitor/blob/master/README.md"><span class="caps">README</span></a>, where all of this stuff gets explained more thoroughly.</p>
<h3>Checking in Termfiles?</h3>
<p>Besides storing the configuration files in the <code>~/.terminitor/</code> directory, you can also store everyhing in a <code>Termfile</code> right inside your project. Checking this file into <a href="http://git-scm.org">Git</a> would allow other developers that work on the same project to use your Terminitor workflow.</p>
<p>This may sound like a great feature but I&#8217;m not too excited about it. First of all, I think personal configuration should never come anywhere near a source code repository since it&#8217;s simply not part of the code or the application.</p>
<p>Also, I want to be able to set up my <em>own</em> workflow (I know using the <code>Termfile</code> doesn&#8217;t keep me from doing that) so I probably don&#8217;t care about yours. If I do, I&#8217;ll ask you to put it in a <a href="http://gist.github.com">Gist</a>.</p>
<p>Lastly, I&#8217;d love to keep using Terminitor an option, so people who choose not to use it shouldn&#8217;t have to deal with extra, meaningless configuration files flying around.</p>
<p>I would suggest <em>not</em> checking it in and keeping it to yourself right now. However, Arthur himself <a href="http://github.com/jeffkreeftmeijer/jeffkreeftmeijer.com/commit/1b7da3c7665c698972ad50f2cb2fcc8f8eb74a73#commitcomment-150393">commented</a> and explained how the <code>Termfile</code> feature could go one step furter in the future and give you the ability to do something like this on a remote repository that has a <code>Termfile</code>:</p>
<pre><code>$ terminitor clone jeffkreeftmeijer navvy</code></pre>
<p>Making it possible to do a one-command setup so you can start hacking on the project immediately. Now <em>that</em> sounds promising.</p>
<h3>What do you think?</h3>
<p>Overall, Terminitor is a really nice tool that saved me a bunch of keystrokes already. I&#8217;m going to keep using it and I&#8217;d love to see what will happen to it in the future. What do you think about Terminitor and the whole <code>Termfile</code> thing? I&#8217;d love to hear your opinion.</p>