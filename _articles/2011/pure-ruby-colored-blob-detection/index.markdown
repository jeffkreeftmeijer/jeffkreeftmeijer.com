<p>Over the last few weeks, I&#8217;ve become increasingly interested in computer vision. After finally getting <a href="http://opencv.willowgarage.com/wiki">OpenCV</a> running, playing around with a little face detection and searching for solutions to weird problems that occurred, I decided to dive a bit deeper into computer vision to figure out how it actually works.</p>
<p><img src="http://jeffkreeftmeijer.com/images/nose_detector.png" alt=""></p>
<p>I started out with blob detection, which simply means detecting, locating and measuring an object in an image. A really simple way of doing something like that (without having to worry about object textures and creepy stuff like that), is to use color to identify blobs. In this article, we&#8217;re going to build a clown&#8217;s nose detector by finding the biggest red blob in an image. We won&#8217;t use any computer vision libraries, the only thing we&#8217;ll need is <a href="https://github.com/wvanbergen/chunky_png">ChunkyPNG</a> by <a href="http://twitter.com/wvanbergen" title="Willem van Bergen">@wvanbergen</a> (but you can use any library that allows you to loop over a image&#8217;s pixels).</p>
<p><img src="http://jeffkreeftmeijer.com/images/bassie.png" style="width:100px; height:100px;"></p>
<p>Here&#8217;s the image we&#8217;ll be working with. If you&#8217;re interested, it&#8217;s Bassie from the dutch circus duo <a href="http://en.wikipedia.org/wiki/Bassie_%26_Adriaan">Bassie &amp; Adriaan</a>. The important thing about this image is that the nose is the biggest red object, since we won&#8217;t really be <em>recognizing</em> things as clowns&#8217; noses, we&#8217;re just <em>detecting</em> red objects.</p>
<h3>Binary images</h3>
<p>First, we load in the image and simplify it to make it easier to work with. Since we&#8217;re only interested in the red pixels, we can turn the original image into a binary one. We go over each of the original image&#8217;s pixels and figure out it&#8217;s redness. If the pixel is red enough (we&#8217;ll use a threshold of 100/255), we give it a value of -1, meaning the pixel is interesting but we still have to process it. We don&#8217;t need to do anything with the other pixels, so we&#8217;ll give those a value of 0, these are the background pixels.</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'chunky_png'</span>

<span class="n">image</span> <span class="o">=</span> <span class="ss">ChunkyPNG</span><span class="p">:</span><span class="ss">:Image</span><span class="o">.</span><span class="n">from_file</span><span class="p">(</span><span class="s1">'bassie.png'</span><span class="p">)</span>
<span class="n">working_image</span> <span class="o">=</span> <span class="n">image</span><span class="o">.</span><span class="n">dup</span>

<span class="n">working_image</span><span class="o">.</span><span class="n">pixels</span><span class="o">.</span><span class="n">map!</span> <span class="k">do</span> <span class="o">|</span><span class="n">pixel</span><span class="o">|</span>
  <span class="n">redness</span> <span class="o">=</span> <span class="ss">ChunkyPNG</span><span class="p">:</span><span class="ss">:Color</span><span class="o">.</span><span class="n">r</span><span class="p">(</span><span class="n">pixel</span><span class="p">)</span> <span class="o">-</span> <span class="p">(</span><span class="ss">ChunkyPNG</span><span class="p">:</span><span class="ss">:Color</span><span class="o">.</span><span class="n">g</span><span class="p">(</span><span class="n">pixel</span><span class="p">)</span> <span class="o">+</span> <span class="ss">ChunkyPNG</span><span class="p">:</span><span class="ss">:Color</span><span class="o">.</span><span class="n">b</span><span class="p">(</span><span class="n">pixel</span><span class="p">))</span>
  <span class="n">redness</span> <span class="o">&gt;</span> <span class="mi">100</span> <span class="o">?</span> <span class="o">-</span><span class="mi">1</span> <span class="p">:</span> <span class="mi">0</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Here&#8217;s the working image with the blobs in white and the background pixels in black:</p>
<p><img src="http://jeffkreeftmeijer.com/images/bassie_blobs.png" style="width:100px; height:100px;"></p>
<p>Now we have an image we can work with, let&#8217;s divide the separate blobs so we can measure them individually to figure out which one the nose is. To do this, we&#8217;ll loop over every pixel in the image and see if it has a -1 value because it still needs to be processed. If it does, we&#8217;ll give it a label and add it to an <code>areas</code> array.</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">areas</span><span class="p">,</span> <span class="n">label</span> <span class="o">=</span> <span class="p">{},</span> <span class="mi">0</span>

<span class="n">working_image</span><span class="o">.</span><span class="n">height</span><span class="o">.</span><span class="n">times</span> <span class="k">do</span> <span class="o">|</span><span class="n">y</span><span class="o">|</span>
  <span class="n">working_image</span><span class="o">.</span><span class="n">row</span><span class="p">(</span><span class="n">y</span><span class="p">)</span><span class="o">.</span><span class="n">each_with_index</span> <span class="k">do</span> <span class="o">|</span><span class="n">pixel</span><span class="p">,</span> <span class="n">x</span><span class="o">|</span>
    <span class="p">(</span><span class="n">areas</span><span class="o">[</span><span class="n">label</span> <span class="o">+=</span> <span class="mi">1</span><span class="o">]</span> <span class="o">||=</span> <span class="o">[]</span><span class="p">)</span> <span class="o">&lt;&lt;</span> <span class="o">[</span><span class="n">x</span><span class="p">,</span><span class="n">y</span><span class="o">]</span> <span class="k">if</span> <span class="n">pixel</span> <span class="o">==</span> <span class="o">-</span><span class="mi">1</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>As you probably figured out already, we&#8217;re assigning each pixel with a -1 value a separate label right now. This means pixels in the same blob get different labels. We don&#8217;t want that, since we want to label <em>groups</em> of pixels that belong to the same blob. To do that, we need to check the pixel&#8217;s neighbors too.</p>
<h3>Pixel neighborhoods</h3>
<p>To be able to find connected pixels, we need to know each pixel&#8217;s neighborhood. For this example we&#8217;ll use a 4-neighborhood, which means we use the pixels right above (north), to the right (east), right below (south) and to the left (west) of the current one. The 8-neighborhood also uses the northeast, southeast, southwest and northwest pixels, but we won&#8217;t really need that for something simple like this.</p>
<p>We need to keep in mind that some pixels don&#8217;t have four neighbors, like the one in the top left, which doesn&#8217;t have any north or west neighbors because they would fall out of the image. Luckily, ChunkyPNG has some nice methods to help us figure out if pixels actually exist. We&#8217;ll implement a <code>neighbors</code> method directly into <code>ChunkyPNG::Image</code>:</p>
<div class="highlight">
<pre><code class="ruby">  <span class="k">class</span> <span class="nc">ChunkyPNG</span><span class="o">::</span><span class="no">Image</span>
    <span class="k">def</span> <span class="nf">neighbors</span><span class="p">(</span><span class="n">x</span><span class="p">,</span><span class="n">y</span><span class="p">)</span>
      <span class="o">[[</span><span class="n">x</span><span class="p">,</span> <span class="n">y</span><span class="o">-</span><span class="mi">1</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="n">x</span><span class="o">+</span><span class="mi">1</span><span class="p">,</span> <span class="n">y</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="n">x</span><span class="p">,</span> <span class="n">y</span><span class="o">+</span><span class="mi">1</span><span class="o">]</span><span class="p">,</span> <span class="o">[</span><span class="n">x</span><span class="o">-</span><span class="mi">1</span><span class="p">,</span> <span class="n">y</span><span class="o">]].</span><span class="n">select</span> <span class="k">do</span> <span class="o">|</span><span class="n">xy</span><span class="o">|</span>
        <span class="n">include_xy?</span><span class="p">(</span><span class="o">*</span><span class="n">xy</span><span class="p">)</span>
      <span class="k">end</span>
    <span class="k">end</span>
  <span class="k">end</span>
</code></pre>
</div>
<p>Using our new neighborhood method, we can improve the blob separator we wrote earlier. We implement a method named <code>label_recursively</code>, which assigns a label to the current pixel, adds the current pixel to the <code>areas</code> array, checks its neighbors and calls itself (without changing the label) on the neighbors if their values are -1 too. When none of the neighbors&#8217; values are -1, the loop will stop until the main loop finds another -1-pixel. If that happens, the label gets increased by 1 and the <code>label_recursively</code> method is called again:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">def</span> <span class="nf">label_recursively</span><span class="p">(</span><span class="n">image</span><span class="p">,</span> <span class="n">areas</span><span class="p">,</span> <span class="n">label</span><span class="p">,</span> <span class="n">x</span><span class="p">,</span> <span class="n">y</span><span class="p">)</span>
  <span class="n">image</span><span class="o">[</span><span class="n">x</span><span class="p">,</span><span class="n">y</span><span class="o">]</span> <span class="o">=</span> <span class="n">label</span>
  <span class="p">(</span><span class="n">areas</span><span class="o">[</span><span class="n">label</span><span class="o">]</span> <span class="o">||=</span> <span class="o">[]</span><span class="p">)</span> <span class="o">&lt;&lt;</span> <span class="o">[</span><span class="n">x</span><span class="p">,</span><span class="n">y</span><span class="o">]</span>

  <span class="n">image</span><span class="o">.</span><span class="n">neighbors</span><span class="p">(</span><span class="n">x</span><span class="p">,</span><span class="n">y</span><span class="p">)</span><span class="o">.</span><span class="n">each</span> <span class="k">do</span> <span class="o">|</span><span class="n">xy</span><span class="o">|</span>
    <span class="k">if</span> <span class="n">image</span><span class="o">[*</span><span class="n">xy</span><span class="o">]</span> <span class="o">==</span> <span class="o">-</span><span class="mi">1</span>
      <span class="n">areas</span><span class="o">[</span><span class="n">label</span><span class="o">]</span> <span class="o">&lt;&lt;</span> <span class="n">xy</span>
      <span class="n">label_recursively</span><span class="p">(</span><span class="n">image</span><span class="p">,</span> <span class="n">areas</span><span class="p">,</span> <span class="n">label</span><span class="p">,</span> <span class="o">*</span><span class="n">xy</span><span class="p">)</span>
    <span class="k">end</span>
  <span class="k">end</span>
<span class="k">end</span>

<span class="n">areas</span><span class="p">,</span> <span class="n">label</span> <span class="o">=</span> <span class="p">{},</span> <span class="mi">0</span>

<span class="n">working_image</span><span class="o">.</span><span class="n">height</span><span class="o">.</span><span class="n">times</span> <span class="k">do</span> <span class="o">|</span><span class="n">y</span><span class="o">|</span>
  <span class="n">working_image</span><span class="o">.</span><span class="n">row</span><span class="p">(</span><span class="n">y</span><span class="p">)</span><span class="o">.</span><span class="n">each_with_index</span> <span class="k">do</span> <span class="o">|</span><span class="n">pixel</span><span class="p">,</span> <span class="n">x</span><span class="o">|</span>
    <span class="n">label_recursively</span><span class="p">(</span><span class="n">working_image</span><span class="p">,</span> <span class="n">areas</span><span class="p">,</span> <span class="n">label</span> <span class="o">+=</span> <span class="mi">1</span><span class="p">,</span> <span class="n">x</span><span class="p">,</span> <span class="n">y</span><span class="p">)</span> <span class="k">if</span> <span class="n">pixel</span> <span class="o">==</span> <span class="o">-</span><span class="mi">1</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>The <code>areas</code> array holds the blobs as labeled groups of pixels now. If we would color the detected blobs, it would look somewhat like this:</p>
<p><img src="http://jeffkreeftmeijer.com/images/bassie_areas.png" style="width:100px; height:100px;"></p>
<p>As you can see, there were some detected areas that overlap and should have been counted as one. This shouldn&#8217;t be a problem for this example, but using an 8-neighborhood can solve some of these issues and make the result more precise, if you end up needing it.</p>
<p>All we have to do to detect the nose is find out which area is the biggest (which one has the most pixels). Since we stored the areas in the <code>areas</code> array, this should be straightforward:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">area</span> <span class="o">=</span> <span class="n">areas</span><span class="o">.</span><span class="n">values</span><span class="o">.</span><span class="n">max</span> <span class="p">{</span> <span class="o">|</span><span class="n">result</span><span class="p">,</span> <span class="n">area</span><span class="o">|</span> <span class="n">result</span><span class="o">.</span><span class="n">length</span> <span class="o">&lt;=&gt;</span> <span class="n">area</span><span class="o">.</span><span class="n">length</span> <span class="p">}</span>
</code></pre>
</div>
<p>Now, <code>area</code> holds an array of the pixels in the blob we&#8217;re interested in. Since we want to put a bounding box around the blob we found, we get the highest and lowest x and y values, create a rectangle on the image using ChunkyPNG&#8217;s drawing tools and save the image:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">x</span><span class="p">,</span> <span class="n">y</span> <span class="o">=</span> <span class="n">area</span><span class="o">.</span><span class="n">map</span><span class="p">{</span> <span class="o">|</span><span class="n">xy</span><span class="o">|</span> <span class="n">xy</span><span class="o">[</span><span class="mi">0</span><span class="o">]</span> <span class="p">},</span> <span class="n">area</span><span class="o">.</span><span class="n">map</span><span class="p">{</span> <span class="o">|</span><span class="n">xy</span><span class="o">|</span> <span class="n">xy</span><span class="o">[</span><span class="mi">1</span><span class="o">]</span> <span class="p">}</span>

<span class="n">image</span><span class="o">.</span><span class="n">rect</span><span class="p">(</span><span class="n">x</span><span class="o">.</span><span class="n">min</span><span class="p">,</span> <span class="n">y</span><span class="o">.</span><span class="n">min</span><span class="p">,</span> <span class="n">x</span><span class="o">.</span><span class="n">max</span><span class="p">,</span> <span class="n">y</span><span class="o">.</span><span class="n">max</span><span class="p">,</span> <span class="ss">ChunkyPNG</span><span class="p">:</span><span class="ss">:Color</span><span class="o">.</span><span class="n">rgb</span><span class="p">(</span><span class="mi">0</span><span class="p">,</span><span class="mi">255</span><span class="p">,</span><span class="mi">0</span><span class="p">))</span>
<span class="n">image</span><span class="o">.</span><span class="n">save</span><span class="p">(</span><span class="s1">'bassie_detected.png'</span><span class="p">)</span>
</code></pre>
</div>
<p>And there you go! We successfully detected, located and measured the biggest red blob in the image:</p>
<p><img src="http://jeffkreeftmeijer.com/images/bassie_detected.png" style="width:100px; height:100px;"></p>
<p>Of course, this method isn&#8217;t fool proof, but it&#8217;s a really simple first step into computer vision. As always, if you used this idea to build something yourself, know of a way to improve the code or have some questions or tips, be sure to let me know. You can find the complete source in <a href="https://gist.github.com/913400">this Gist</a>. Have fun!</p>