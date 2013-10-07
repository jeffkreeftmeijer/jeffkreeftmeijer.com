<div class="notice">Capybara has an RSpec <span class="caps">DSL</span> now, allowing you to steak-acceptance testing without Steak. Be sure to read <a href="http://jeffkreeftmeijer.com/2011/acceptance-testing-using-capybaras-new-rspec-dsl/">Acceptance testing using Capybara’s new RSpec <span class="caps">DSL</span></a> too.</div>
<p>I’m not going to tell you <a href="http://robots.thoughtbot.com/post/543043259/unit-and-functional-tests-are-as-useful-as-100-code">why you should write acceptance (or integration) tests</a>, but you should. I used <a href="http://cukes.info/">Cucumber</a> for a while now and I love it, but I think writing my tests in a <a href="http://www.martinfowler.com/bliki/BusinessReadableDSL.html">business-readable domain-specific language</a> and translating them into Ruby using step definitions is a bit too much sometimes. And I’m not a vegetarian.</p>
<p>Luckily, we have <a href="http://github.com/cavalle/steak">Steak</a> by <a href="http://twitter.com/cavalle" title="Luismi Cavallé">@cavalle</a>:</p>
<p><img src="http://jeffkreeftmeijer.com/images/steak.jpg"></p>
<blockquote>
<p>“Steak is like Cucumber but in plain Ruby. No explicit givens, whens or thens. No steps, no English, just Ruby: RSpec and Steak. That’s all.”</p>
</blockquote>
<p>Right now the stable version of Steak only works with Rails 2.x and <a href="http://rspec.info/">RSpec</a> 1.x, but there’s a <a href="http://github.com/cavalle/steak/tree/rails3">Rails 3 branch</a> where some work is being done to support Rails 3.x and RSpec 2.×. I’ve been using that one, but this article should also be fine for you when you’re on Rails 2.×.</p>
<h3>Installation</h3>
<p>OK, throw this into your <code>Gemfile</code> (I’m specifying the <code>0.4.0.a4</code> release here, that’s the most recent alpha release from the <code>rails3</code> branch). Also, I’ll be using <a href="http://github.com/jnicklas/capybara">Capybara</a> for this example:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">group</span> <span class="ss">:test</span> <span class="k">do</span>
  <span class="n">gem</span> <span class="s1">'steak'</span><span class="p">,</span> <span class="s1">'0.4.0.a4'</span>
  <span class="n">gem</span> <span class="s1">'capybara'</span>
<span class="k">end</span>
</code></pre>
</div>
<p>And install your bundle:</p>
<pre><code>$ bundle install</code></pre>
<p>Or — if you’re using Rails 2.x — put this in <code>config/environment.rb</code> (Just using the stable Rails 2 release of Steak here):</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'steak'</span>
<span class="n">config</span><span class="o">.</span><span class="n">gem</span> <span class="s1">'capybara'</span>
</code></pre>
</div>
<p>And run:</p>
<pre><code>$ rake gems:install RAILS_ENV=test</code></pre>
<p>Now you can use the Steak generators to set everything up. You have to specify which driver you’re using (Steak also has a generator for <a href="http://github.com/brynary/webrat">Webrat</a>):</p>
<pre><code>$ rails generate steak --capybara # or -- webrat</code></pre>
<p>Please remember to use <code>script/generate</code> instead of <code>rails generate</code> when on Rails 2.×.</p>
<p>The generator created the <code>spec/acceptance</code> directory in your project, in which you can find <code>acceptance_helper.rb</code> and the <code>support</code> directory. The <code>support</code> directory holds <code>paths.rb</code> — which should be familiar if you’ve used Cucumber before — and <code>helpers.rb</code>.</p>
<h3>Acceptance specs</h3>
<p>Now, let’s write our first acceptance spec — no, we’re not calling it a “feature”. It’s a spec. — by using another generator (I’m creating an articles spec here):</p>
<pre><code>$ rails generate acceptance_spec articles</code></pre>
<p>Steak generated <code>spec/acceptance/articles_spec.rb</code>, which looks like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="nb">require</span> <span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span> <span class="o">+</span> <span class="s1">'/acceptance_helper'</span>

<span class="n">feature</span> <span class="s2">"Feature name"</span><span class="p">,</span> <span class="sx">%q{</span>
<span class="sx">  In order to ...</span>
<span class="sx">  As a ...</span>
<span class="sx">  I want to ...</span>
<span class="sx">}</span> <span class="k">do</span>

  <span class="n">scenario</span> <span class="s2">"Scenario name"</span> <span class="k">do</span>
    <span class="kp">true</span><span class="o">.</span><span class="n">should</span> <span class="o">==</span> <span class="kp">true</span>
  <span class="k">end</span>

<span class="k">end</span>
</code></pre>
</div>
<p>If you’re a Cucumber user, the feature description should look familiar. I’ll try to describe what I’m doing like this:</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">feature</span> <span class="s2">"Articles"</span><span class="p">,</span> <span class="sx">%q{</span>
<span class="sx">  In order to have an awesome blog</span>
<span class="sx">  As an author</span>
<span class="sx">  I want to create and manage articles</span>
<span class="sx">}</span> <span class="k">do</span>
</code></pre>
</div>
<p>Great. On to our first scenario. In the articles index we want to show all articles in a list.</p>
<div class="highlight">
<pre><code class="ruby"><span class="n">scenario</span> <span class="s2">"Article index"</span> <span class="k">do</span>
  <span class="no">Article</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:title</span> <span class="o">=&gt;</span> <span class="s1">'One'</span><span class="p">)</span>
  <span class="no">Article</span><span class="o">.</span><span class="n">create!</span><span class="p">(</span><span class="ss">:title</span> <span class="o">=&gt;</span> <span class="s1">'Two'</span><span class="p">)</span>
  <span class="n">visit</span> <span class="n">article_index</span>
  <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span><span class="p">(</span><span class="s1">'One'</span><span class="p">)</span>
  <span class="n">page</span><span class="o">.</span><span class="n">should</span> <span class="n">have_content</span><span class="p">(</span><span class="s1">'Two'</span><span class="p">)</span>
<span class="k">end</span>
</code></pre>
</div>
<p>First, I create two articles called “One” and “Two” (please, use a tool like <a href="http://github.com/notahat/machinist">Machinist</a> for that). Then I visit <code>article_index</code> and check if the article titles show up. Really simple.</p>
<p>The last thing to do to get this thing running is to create the path for <code>article_index</code> in <code>spec/acceptance/support/paths.rb</code>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">module</span> <span class="nn">NavigationHelpers</span>
  <span class="k">def</span> <span class="nf">homepage</span>
    <span class="s2">"/"</span>
  <span class="k">end</span>

  <span class="k">def</span> <span class="nf">article_index</span>
    <span class="s2">"/articles"</span>
  <span class="k">end</span>
<span class="k">end</span>
</code></pre>
</div>
<p>Simple, right? I’m not going to walk you through building and testing this application here right now, but I think you get the point.</p>
<h3>Minimalist acceptance testing</h3>
<p>Steak just provides some aliases (like <code>scenario</code> and <code>feature</code>) for RSpec’s methods “providing you with the language of acceptance testing”. Here’s a snippet from  <a href="http://github.com/cavalle/steak/blob/master/lib/steak.rb">Steak’s library</a>:</p>
<div class="highlight">
<pre><code class="ruby"><span class="k">module</span> <span class="nn">Spec::Example::ExampleGroupMethods</span>
  <span class="k">alias</span> <span class="n">scenario</span> <span class="n">example</span>
  <span class="k">alias</span> <span class="n">background</span> <span class="n">before</span>
<span class="k">end</span>

<span class="k">module</span> <span class="nn">Spec::DSL::Main</span>
  <span class="k">alias</span> <span class="n">feature</span> <span class="n">describe</span>
<span class="k">end</span>
</code></pre>
</div>
<p>So, if you know your RSpec, the only thing you’ll have to do is dive into <a href="http://github.com/jnicklas/capybara">Capybara</a> (or <a href="http://github.com/brynary/webrat">Webrat</a>) for a bit and you’ll be writing acceptance specs in no time.</p>
<h3>Running your spec</h3>
<p>You might have guessed, but running your acceptance specs is exactly the same as running any other spec. After all, it’s just a minimal layer on top of RSpec:</p>
<pre><code>$ spec spec/acceptance/articles_spec.rb</code></pre>
<h3>Cucumber vs Steak?</h3>
<p>Cucumber is highly focused on creating a business-readable <span class="caps">DSL</span>, and does so perfectly. I understand the thought behind making stakeholders able to read what’s going on in their projects, but I wonder how many people actually do this. Also, one might argue that — from a Ruby programmer’s perspective — Steak’s specs are in fact more readable than Cucumber’s.</p>
<p>Steak takes away the extra step of translating everything from English to Ruby and is incredibly easy to learn (especially when you have some RSpec experience). It’s completely incomparable to Cucumber though and which one to choose is simply a matter of taste. And I love me some Steak.</p>