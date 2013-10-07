<p>If you follow any of us on Twitter, you probably know <a href="http://80beans.com">80beans</a> went to <a href="http://rubyandrails.eu">RubyAndRails</a> in Amsterdam last week. In this weeks article, I’ll try to explain what inspired me the most. If you need a <em>proper</em> talk overview, check out <a href="http://rubyandrails.eu/blog">the RubyAndRails blog</a>.</p>
<h3>Rails 3 Mountable apps</h3>
<p><a href="http://twitter.com/drogus" title="Piotr Sarnacki">@drogus</a> gave a talk about the work he did on mountable applications in Rails 3 during the <a href="http://rubysoc.org/">Ruby Summer of Code</a>. While the ultimate goal was to have multiple Rails applications running in a single process, development switched to boosting the (existing) Rails Engines to be “almost as powerful as applications”. In fact, the only difference is that engines have to be mounted and can’t be run standalone.</p>
<p>I had a brief but very inspiring chat with Piotr during the Geek dinner and I’m sure we’ll hear a lot from him in the future.</p>
<h3>Live music-hacking-jam-session</h3>
<p><a href="http://twitter.com/rosejn" title="Jeff Rose">@rosejn</a> and <a href="http://twitter.com/samaaron" title="Sam Aaron">@samaaron</a> (the <a href="http://twitter.com/lambdatones" title="λ-tones">@lambdatones</a>) gave a presentation on building audio synthesizers with <a href="http://project-overtone.org/">Overtone</a> and playing music in Clojure. They even did an amazing <a href="http://www.youtube.com/watch?v=WXovdAEV_mI&amp;hd=1">live music-hacking-jam-session</a>.</p>
<p><img src="http://jeffkreeftmeijer.com/images/lambdatones.jpg" alt=""></p>
<h3>Profiling and Frankenstein programming</h3>
<p><a href="http://twitter.com/chastell" title="Piotr Szotkowski">@chastell</a> dove into <a href="http://projecteuler.net/index.php?section=problems&amp;id=10">Project Euler’s problem #10</a> and found out finding the sum of all the primes below two million got extremely slow in Ruby. In his talk, he went over a couple of profiling tools and eventually went with <a href="http://github.com/tmm1/perftools.rb/">perftools.rb</a> for having the least overhead. After that, he went on tweaking the calculation code and eventually using <a href="http://www.zenspider.com/ZSS/Products/RubyInline/">RubyInline</a> to be able to use inline C, creating a really fast Frankenstein of languages.</p>
<h3>Fighter jet pilots</h3>
<p><a href="http://twitter.com/coreyhaines" title="Corey Haines">@coreyhaines</a> did an amazingly inspiring talk about a lot of things we (should) already know — like <span class="caps">BDD</span> and pair programming — but also reminded us of how awesome our profession is, without even coming close to the awesomeness of being a fighter jet pilot. He urged everyone in the room to practice more to become happier programmers.</p>
<blockquote>
<p>“ How did you get so happy?, Because I practiced and now I’m awesome at programming. ”</p>
</blockquote>
<p>I’m still not sure why I missed the <a href="http://coderetreat.com/">Code Retreat</a> on Saturday.</p>
<h3>Fancy programming</h3>
<p><a href="http://twitter.com/bakkdoor" title='Christopher "Mr. Fancy" Bertels'>@bakkdoor</a> gave a talk about his programming language called <a href="http://www.fancy-lang.org/">Fancy</a>. Inspired by Smalltalk, Ruby and Erlang and running on Rubinius since a couple of weeks, Fancy aims to be a reasonably fast truly object oriented dynamic language that’s easy to understand.</p>
<p>Fancy was written for fun and it seems like an amazing way to learn about programming in general:</p>
<blockquote>
<p>“ We’re very open to discussion on anything related to the language, its features or semantics. It’s about the fun after all. ”</p>
</blockquote>
<h3>Mining for RubyGems</h3>
<p><a href="http://fngtps.com">Fingertips</a> won this years <a href="http://rubyandrails.eu/rumble">Rumble</a> with <a href="http://github.com/Fingertips/miner">Miner</a>: a simple MacRuby application that displays interesting new projects in an App Store for Rubygems, complete with one-click installation. This application and its <a href="http://minerapp.com">online counterpart</a> were built in under eight hours. How’s that for inspiring?</p>
<h3>See you all next year!</h3>
<p>There were a lot more interesting talks, but these were some that inspired me to get my hands dirty again. I had a lot of fun and I talked to a lot of interesting people during the pre-party, the Github meetup and the Geek dinner. Thanks everyone, I hope to see you all again next year!</p>