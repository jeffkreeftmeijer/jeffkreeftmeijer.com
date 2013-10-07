<div class="notice" id="mouse_toggle">
If you see extra mouse cursors moving around: don&#8217;t worry, they&#8217;re part of the demo. You can always <a href="#">disable</a> them if you want.
</div>
<p>Since my first two articles about my <a href="http://nodejs.org">Node.js</a> experiment were a great success, got a lot of reponses and even inspired some people to get their hands dirty, I decided to dive into the demo code once more and write a very last article about it.</p>
<p>If you have no idea what this is all about, please start by reading &#8220;<a href="http://jeffkreeftmeijer.com/2010/experimenting-with-node-js">Experimenting with Node.js</a>&#8221; and &#8220;<a href="http://jeffkreeftmeijer.com/2010/things-i-learned-from-my-node.js-experiment">Things I learned from my Node.js experiment</a>&#8221;.</p>
<p>This time, I&#8217;ve added the ability to chat with other cursors &#8212; with <a href="http://en.gravatar.com">Gravatar</a> support! &#8212; you can try it out by putting your e-mail address in the left input, your message in the right and hitting enter.</p>
<form id="chat">
<input class="placeholder" id="email" placeholder="E-mail address"><input class="placeholder" id="text" maxlength="140" placeholder="Message"><input type="submit" style="display:none;">
</form>
<p class="small">I&#8217;m only using your e-mail address to fetch your Gravatar. I&#8217;m not saving anything.</p>
<p>When you submit the form, it sends your e-mail address and message to the web socket server. After your e-mail address is encrypted to MD5 with Node&#8217;s <a href="http://nodejs.org/api.html#crypto-236">crypto</a> module, it gets broadcasted to the other clients together with your message:</p>
<div class="highlight">
<pre><code class="javascript"><span class="k">if</span><span class="p">(</span><span class="nx">request</span><span class="p">.</span><span class="nx">action</span> <span class="o">==</span> <span class="s1">'speak'</span><span class="p">)</span> <span class="p">{</span>
  <span class="nx">request</span><span class="p">.</span><span class="nx">email</span> <span class="o">=</span> <span class="nx">crypto</span><span class="p">.</span><span class="nx">createHash</span><span class="p">(</span><span class="s1">'md5'</span><span class="p">).</span>
                  <span class="nx">update</span><span class="p">(</span><span class="nx">request</span><span class="p">.</span><span class="nx">email</span><span class="p">).</span><span class="nx">digest</span><span class="p">(</span><span class="s2">"hex"</span><span class="p">);</span>
  <span class="nx">client</span><span class="p">.</span><span class="nx">send</span><span class="p">(</span><span class="nx">json</span><span class="p">(</span><span class="nx">request</span><span class="p">));</span>
<span class="p">}</span>

<span class="nx">request</span><span class="p">.</span><span class="nx">id</span> <span class="o">=</span> <span class="nx">client</span><span class="p">.</span><span class="nx">sessionId</span>
<span class="nx">client</span><span class="p">.</span><span class="nx">broadcast</span><span class="p">(</span><span class="nx">json</span><span class="p">(</span><span class="nx">request</span><span class="p">));</span>
</code></pre>
</div>
<p>The encrypted e-mail address and message also get sent back to the client it came from, to be able to show users their own messages after sending them out.</p>
<p>When the message gets received on the client side, a bit of <a href="http://jquery.com">jQuery</a> makes sure the Gravatar and the message get displayed:</p>
<div class="highlight">
<pre><code class="javascript"><span class="kd">function</span> <span class="nx">speak</span><span class="p">(</span><span class="nx">data</span><span class="p">){</span>
  <span class="nx">clearTimeout</span><span class="p">(</span><span class="nx">timeouts</span><span class="p">[</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]]);</span>
  <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span><span class="o">+</span><span class="s1">' img'</span><span class="p">).</span><span class="nx">remove</span><span class="p">();</span>
  <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]).</span><span class="nx">append</span><span class="p">(</span><span class="s1">'&lt;img src="http://www.gravatar.com/avatar/'</span> <span class="o">+</span> <span class="nx">data</span><span class="p">[</span><span class="s1">'email'</span><span class="p">]</span> <span class="o">+</span> <span class="s1">'?s=20" /&gt;'</span><span class="p">);</span>
    
  <span class="k">if</span><span class="p">(</span><span class="nx">data</span><span class="p">[</span><span class="s1">'text'</span><span class="p">]</span> <span class="o">==</span> <span class="s1">''</span><span class="p">)</span> <span class="p">{</span>    
    <span class="k">return</span> <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span><span class="o">+</span><span class="s1">' .chat'</span><span class="p">).</span><span class="nx">hide</span><span class="p">();</span>
  <span class="p">}</span>
  
  <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span><span class="o">+</span><span class="s1">' .chat'</span><span class="p">).</span><span class="nx">show</span><span class="p">().</span><span class="nx">html</span><span class="p">(</span><span class="nx">data</span><span class="p">[</span><span class="s1">'text'</span><span class="p">]);</span>   
  <span class="nx">timeouts</span><span class="p">[</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]]</span> <span class="o">=</span> <span class="nx">setTimeout</span><span class="p">(</span><span class="s2">"$('#mouse_"</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span><span class="o">+</span><span class="s2">" .chat').hide()"</span><span class="p">,</span> <span class="mi">5000</span><span class="p">)</span>
<span class="p">};</span>
</code></pre>
</div>
<p>Also, a timeout gets created that removes the message from the screen after five seconds to try to keep your screen from overflowing.</p>
<p>Like before, the <a href="http://gist.github.com/488562">Gist</a> with all the code I wrote for the experiment is updated in case you want to use it to build something awesome. If you do, please let me know. I&#8217;d love to see what you come up with and I might even write another very last article.</p>
<p>That wraps up my Node.js-web-socket-mouse-cursor-experiment, thanks again for the responses everyone. You certainly helped me out a lot trying to build this thing. As you might have guessed, I&#8217;m seriously excited about Node.js and there will probably be more experiments and articles like this.</p>
<p>Stay tuned and please let me know how you liked the experiment in the comments.</p>