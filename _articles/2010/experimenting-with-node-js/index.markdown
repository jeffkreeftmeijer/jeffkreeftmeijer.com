<div class="notice" id="mouse_toggle">
If you see extra mouse cursors moving around: don&#8217;t worry, they&#8217;re part of the demo. You can always <a href="#">disable</a> them if you want.
</div>
<div class="notice">
I&#8217;ve written a <a href="http://jeffkreeftmeijer.com/2010/things-i-learned-from-my-node.js-experiment/">follow-up</a> on this article, in which I improved a lot of the code. Be sure to read that one too!
</div>
<p>If you&#8217;re using a browser that supports web sockets, you might see some extra mouse cursors moving around. These are actually other people also looking at this page right now, live, as we speak. If you don&#8217;t see anything, try to open up this page in another browser window next to this one and move your mouse in it.</p>
<p>This is an experiment I did to play around with <a href="http://nodejs.org">Node.js</a> and web sockets. I&#8217;ve put <a href="http://gist.github.com/488562">everything in a Gist</a> in case you want to try it out yourself. I&#8217;ll explain how it works in this article.</p>
<h3>Web socket server</h3>
<p>Using <a href="http://twitter.com/miksago">@miksago</a>&#8216;s <a href="http://github.com/miksago/node-websocket-server">node-websocket-server</a> made it extremely easy to send and receive messages from a web socket. Here&#8217;s the code that runs the server:</p>
<div class="highlight">
<pre><code class="javascript"><span class="kd">var</span> <span class="nx">ws</span> <span class="o">=</span> <span class="nx">require</span><span class="p">(</span><span class="nx">__dirname</span> <span class="o">+</span> <span class="s1">'/lib/ws'</span><span class="p">),</span>
    <span class="nx">server</span> <span class="o">=</span> <span class="nx">ws</span><span class="p">.</span><span class="nx">createServer</span><span class="p">();</span>

<span class="nx">server</span><span class="p">.</span><span class="nx">addListener</span><span class="p">(</span><span class="s2">"connection"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">conn</span><span class="p">){</span>
  <span class="nx">conn</span><span class="p">.</span><span class="nx">addListener</span><span class="p">(</span><span class="s2">"message"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">message</span><span class="p">){</span>
    <span class="nx">message</span> <span class="o">=</span> <span class="nx">JSON</span><span class="p">.</span><span class="nx">parse</span><span class="p">(</span><span class="nx">message</span><span class="p">);</span>
    <span class="nx">message</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span> <span class="o">=</span> <span class="nx">conn</span><span class="p">.</span><span class="nx">id</span>
    <span class="nx">conn</span><span class="p">.</span><span class="nx">broadcast</span><span class="p">(</span><span class="nx">JSON</span><span class="p">.</span><span class="nx">stringify</span><span class="p">(</span><span class="nx">message</span><span class="p">));</span>
  <span class="p">});</span>
<span class="p">});</span>

<span class="nx">server</span><span class="p">.</span><span class="nx">addListener</span><span class="p">(</span><span class="s2">"close"</span><span class="p">,</span> <span class="kd">function</span><span class="p">(</span><span class="nx">conn</span><span class="p">){</span>
  <span class="nx">conn</span><span class="p">.</span><span class="nx">broadcast</span><span class="p">(</span><span class="nx">JSON</span><span class="p">.</span><span class="nx">stringify</span><span class="p">({</span><span class="s1">'id'</span><span class="o">:</span> <span class="nx">conn</span><span class="p">.</span><span class="nx">id</span><span class="p">,</span> <span class="s1">'action'</span><span class="o">:</span> <span class="s1">'close'</span><span class="p">}));</span>
<span class="p">});</span>

<span class="nx">server</span><span class="p">.</span><span class="nx">listen</span><span class="p">(</span><span class="mi">8000</span><span class="p">);</span>
</code></pre>
</div>
<p>After including the node-websocket-server library and creating the server, I add some listeners to know when clients disconnect or send a message and make sure messages get sent to the other clients. Whenever it receives a <span class="caps">JSON</span> message, it includes the connection&#8217;s id before broadcasting it to the clients to make it possible to find out which cursor we need to move.</p>
<p>I saved it as <code>server.js</code>, so starting the server is as simple as running <code>node server.js</code>. To make sure it keeps running, I daemonized it with <a href="http://god.rubyforge.org/">God</a>, using the same config file I used in the &#8220;<a href="http://jeffkreeftmeijer.com/2010/daemonizing-navvy-with-god">Daemonizing Navvy with God</a>&#8221; article.</p>
<h3>Receiving messages</h3>
<p>Now, in a regular javascript file &#8212; with some <a href="http://jquery.com">jQuery</a> &#8212; I included into this page, I connect to the web socket like this:</p>
<div class="highlight">
<pre><code class="javascript"><span class="kd">var</span> <span class="nx">conn</span><span class="p">;</span>
<span class="kd">var</span> <span class="nx">connect</span> <span class="o">=</span> <span class="kd">function</span><span class="p">()</span> <span class="p">{</span>
  <span class="k">if</span> <span class="p">(</span><span class="nb">window</span><span class="p">[</span><span class="s2">"WebSocket"</span><span class="p">])</span> <span class="p">{</span>
    <span class="nx">conn</span> <span class="o">=</span> <span class="k">new</span> <span class="nx">WebSocket</span><span class="p">(</span><span class="s2">"ws://jeffkreeftmeijer.com:8000"</span><span class="p">);</span>
    <span class="nx">conn</span><span class="p">.</span><span class="nx">onmessage</span> <span class="o">=</span> <span class="kd">function</span><span class="p">(</span><span class="nx">evt</span><span class="p">)</span> <span class="p">{</span>
      <span class="nx">data</span> <span class="o">=</span> <span class="nx">JSON</span><span class="p">.</span><span class="nx">parse</span><span class="p">(</span><span class="nx">evt</span><span class="p">.</span><span class="nx">data</span><span class="p">);</span>
      <span class="k">if</span><span class="p">(</span><span class="nx">data</span><span class="p">[</span><span class="s1">'action'</span><span class="p">]</span> <span class="o">==</span> <span class="s1">'close'</span><span class="p">){</span>
        <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">data</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]).</span><span class="nx">remove</span><span class="p">();</span>
      <span class="p">}</span> <span class="k">else</span> <span class="k">if</span><span class="p">(</span><span class="nx">data</span><span class="p">[</span><span class="s1">'action'</span><span class="p">]</span> <span class="o">==</span> <span class="s1">'move'</span><span class="p">){</span>
        <span class="nx">move</span><span class="p">(</span><span class="nx">data</span><span class="p">);</span>
      <span class="p">};</span>
    <span class="p">};</span>
  <span class="p">}</span>
<span class="p">};</span>

<span class="nb">window</span><span class="p">.</span><span class="nx">onload</span> <span class="o">=</span> <span class="nx">connect</span><span class="p">;</span>
</code></pre>
</div>
<p>As you can see, this connects to the server we just started. When a message is received, it checks the action it&#8217;s supposed to perform. If the action is &#8220;move&#8221;, it&#8217;ll move a mouse cursor on the screen using the <code>move()</code> function I&#8217;ll show you later. If it&#8217;s &#8220;close&#8221;, it means that the client disconnected and his cursor has to be removed from the screen.</p>
<h3>Sending messages</h3>
<p>Now we&#8217;re able to receive messages, move and delete cursors. The last thing we need is the client to be able to send out messages:</p>
<div class="highlight">
<pre><code class="javascript"><span class="nx">$</span><span class="p">(</span><span class="nb">document</span><span class="p">).</span><span class="nx">mousemove</span><span class="p">(</span>
  <span class="nx">ratelimit</span><span class="p">(</span><span class="kd">function</span><span class="p">(</span><span class="nx">e</span><span class="p">){</span>
    <span class="k">if</span> <span class="p">(</span><span class="nx">conn</span><span class="p">)</span> <span class="p">{</span>
      <span class="nx">conn</span><span class="p">.</span><span class="nx">send</span><span class="p">(</span><span class="nx">JSON</span><span class="p">.</span><span class="nx">stringify</span><span class="p">({</span>
        <span class="s1">'action'</span><span class="o">:</span> <span class="s1">'move'</span><span class="p">,</span>
        <span class="s1">'x'</span><span class="o">:</span> <span class="nx">e</span><span class="p">.</span><span class="nx">pageX</span><span class="p">,</span>
        <span class="s1">'y'</span><span class="o">:</span> <span class="nx">e</span><span class="p">.</span><span class="nx">pageY</span><span class="p">,</span>
        <span class="s1">'w'</span><span class="o">:</span> <span class="nx">$</span><span class="p">(</span><span class="nb">window</span><span class="p">).</span><span class="nx">width</span><span class="p">(),</span>
        <span class="s1">'h'</span><span class="o">:</span> <span class="nx">$</span><span class="p">(</span><span class="nb">window</span><span class="p">).</span><span class="nx">height</span><span class="p">()</span>
      <span class="p">}));</span>
    <span class="p">}</span>
  <span class="p">},</span> <span class="mi">40</span><span class="p">)</span>
<span class="p">);</span>
</code></pre>
</div>
<p>Whenever you move your mouse, the <code>.mousemouse()</code> function gets triggered that sends some <span class="caps">JSON</span> with the mouse position and screen size to the socket. The <code>ratelimit</code> method makes sure that there&#8217;s a forty millisecond interval between messages.</p>
<h3>Moving the cursors</h3>
<p>So, when the other clients receive a &#8220;move&#8221; message, it calls the <code>move()</code> function, like I showed you before. It looks like this:</p>
<div class="highlight">
<pre><code class="javascript"><span class="kd">function</span> <span class="nx">move</span><span class="p">(</span><span class="nx">mouse</span><span class="p">){</span>
  <span class="k">if</span><span class="p">(</span><span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">mouse</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]).</span><span class="nx">length</span> <span class="o">==</span> <span class="mi">0</span><span class="p">)</span> <span class="p">{</span>
    <span class="nx">$</span><span class="p">(</span><span class="s1">'body'</span><span class="p">).</span><span class="nx">append</span><span class="p">(</span>
      <span class="s1">'&lt;div class="mouse" id="mouse_'</span><span class="o">+</span><span class="nx">mouse</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]</span><span class="o">+</span><span class="s1">'"/&gt;'</span>
    <span class="p">);</span>
  <span class="p">}</span>

  <span class="nx">$</span><span class="p">(</span><span class="s1">'#mouse_'</span><span class="o">+</span><span class="nx">mouse</span><span class="p">[</span><span class="s1">'id'</span><span class="p">]).</span><span class="nx">css</span><span class="p">({</span>
    <span class="s1">'left'</span> <span class="o">:</span> <span class="p">((</span><span class="nx">$</span><span class="p">(</span><span class="nb">window</span><span class="p">).</span><span class="nx">width</span><span class="p">()</span> <span class="o">-</span> <span class="nx">mouse</span><span class="p">[</span><span class="s1">'w'</span><span class="p">])</span> <span class="o">/</span> <span class="mi">2</span> <span class="o">+</span> <span class="nx">mouse</span><span class="p">[</span><span class="s1">'x'</span><span class="p">])</span> <span class="o">+</span> <span class="s1">'px'</span><span class="p">,</span>
    <span class="s1">'top'</span> <span class="o">:</span> <span class="nx">mouse</span><span class="p">[</span><span class="s1">'y'</span><span class="p">]</span> <span class="o">+</span> <span class="s1">'px'</span>
  <span class="p">})</span>
</code></pre>
</div>
<p>It creates a div for the new mouse if it doesn&#8217;t exist yet and moves it to the right position. Also, the x-position of the mouse gets calculated while keeping the difference in screen size in mind. This way it gets calculated from the center of the page, instead of from the left.</p>
<h3>Blew your mind?</h3>
<p>Tracking mouse movement and showing cursors to other clients is cool, but not useful in any way (although you could think of some cool use-cases for this). What this example <em>does</em> show is that you can do pretty impressive things using web sockets and Node.js. And it was a great excuse to play around with it.</p>
<p>This was the first thing I did using Node.js, so the code is probably far from perfect. If you know a way to improve it, please <a href="http://gist.github.com/488562">fork the Gist</a> and show me how it should be done. I&#8217;ll update the article.</p>
<p>I&#8217;m excited about Node.js and I&#8217;ll probably write and play around with it some more in the future, so stay tuned.</p>