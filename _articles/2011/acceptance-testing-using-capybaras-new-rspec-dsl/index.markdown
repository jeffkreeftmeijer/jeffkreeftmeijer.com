<p>I’ve been using <a href="https://github.com/cavalle/steak">Steak</a> for almost a year now. It’s an <a href="https://github.com/rspec">RSpec</a> extension by <a href="http://twitter.com/cavalle" title="Luismi Cavallé">@cavalle</a> to allow you to get up and running doing acceptance testing. Since then I <a href="http://jeffkreeftmeijer.com/2010/steak-because-cucumber-is-for-vegetarians">wrote</a> and <a href="http://jeffkreeftmeijer.com/2011/herbivore-carnivore">talked</a> about it a lot and it definitely helped me to get into acceptance testing without having to get out of RSpec and writing tests in English.</p>
<p>What a lot of people don’t know is that Steak is nothing more than a bunch of aliases and generators. This doesn’t mean that it doesn’t make your work easier or that it’s a <a href="http://twitter.com/#!/wycats/status/26769271290">scam</a>, but it’s not a completely separate testing library. It’s essentially just a tool to make it easier to get <a href="https://github.com/jnicklas/capybara">Capybara</a> running on RSpec.</p>
<p><img src="http://jeffkreeftmeijer.com/images/carnivore_capybara.png" alt=""><br><span class="small">Carnivore Capybara!!!1 Roaargh!</span></p>
<p>Back when Steak was first released, Capybara didn’t have any of the nice RSpec helpers it does now. A lot has changed since. Besides the helpers, <a href="https://github.com/jnicklas/capybara/commit/f4897f890d8dd33215fef238902988e8823a6539">it got its own RSpec acceptance testing <span class="caps">DSL</span></a> recently, essentially eating Steak’s functionality and turning it into a complete acceptance testing solution (on top of RSpec).</p>
<h3>Acceptance testing with Capybara</h3>
<p>The <span class="caps">DSL</span> is’nt officially released yet, but <a href="http://twitter.com/#!/jncoward/status/36102623924850688">it will be available in Capybara 1.0</a>. Right now, you’ll have to get it from git if you want to use it.</p>
<p>Let’s say you’re working on a Rails project using Bundler. Simply add RSpec and Capybara to your <code>Gemfile</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">group</span> <span class="ss">:test</span> <span class="k">do</span>
  <span class="n">gem</span> <span class="s1">'rspec-rails'</span>
  <span class="n">gem</span> <span class="s1">'capybara'</span><span class="p">,</span> <span class="ss">:git</span> <span class="o">=&gt;</span> <span class="s1">'git://github.com/jnicklas/capybara.git'</span>
<span class="k">end</span>
</code></pre>
</div>
<p>After running <code>bundle install</code>, set up RSpec like you’re used to:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> rails g rspec:install
<span class="go">      create  .rspec</span>
<span class="go">      create  spec</span>
<span class="go">      create  spec/spec_helper.rb</span>
</code></pre>
</div>
<p>Capybara doesn’t have any generators for its new <span class="caps">DSL</span>, but that shouldn’t be a problem. Setting it up is quite easy, just add a file named <code>spec/acceptance/acceptance_helper.rb</code>. In this file, we’ll require <code>spec/spec_helper.rb</code> to make RSpec available. We’ll also require Capybara’s RSpec helper file:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'rspec'</span>
<span class="nb">require</span> <span class="s1">'capybara/rspec'</span>
</code></pre>
</div>
<p>Capybara will now automatically hook into RSpec and allow you to write your first test. See? I told you we weren’t going to need any generators. Let’s write a spec named <code>spec/acceptance/articles_spec.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="s1">'acceptance/acceptance_helper'</span>

<span class="n">feature</span> <span class="s2">"Articles"</span><span class="p">,</span> <span class="sx">%q{</span>
<span class="sx">  In order to have an awesome blog</span>
<span class="sx">  As an author</span>
<span class="sx">  I want to create and manage articles</span>
<span class="sx">}</span> <span class="k">do</span>

  <span class="n">background</span> <span class="k">do</span>
    <span class="no">Article</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:title</span> <span class="o">=&gt;</span> <span class="s1">'One'</span><span class="p">)</span>
    <span class="no">Article</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:title</span> <span class="o">=&gt;</span> <span class="s1">'Two'</span><span class="p">)</span>
  <span class="k">end</span>

  <span class="n">scenario</span> <span class="s2">"Article index"</span> <span class="k">do</span>
    <span class="n">visit</span> <span class="s1">'/articles'</span>
    <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span><span class="p">(</span><span class="s1">'One'</span><span class="p">)</span>
    <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span><span class="p">(</span><span class="s1">'Two'</span><span class="p">)</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>As you can see, we’re using methods like <code>feature</code>, <code>background</code> and <code>scenario</code> instead of <code>context</code>, <code>before</code> and <code>example</code>, just like we did in Steak. Now, you can run your new spec like any other RSpec test:</p>
<div class="highlight">
<pre><code class="console"><span class="gp">$</span> rspec spec/acceptance/articles_spec.rb
</code></pre>
</div>
<p>There you go. A complete acceptance testing solution including the acceptance testing slang, without generators and just a couple of lines of code. What do you think? Do you have any ideas to make this more awesome? Definitely let me know!</p>