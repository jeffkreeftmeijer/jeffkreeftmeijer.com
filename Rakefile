require 'asciidoctor'
require 'asciidoctor-html5s'
require 'erb'
require 'date'

def command(command)
  puts command
  puts `#{command}`
end

task :generate => [:bundle, :copy, :build]

task :build do
  {
    '_articles/git-flow/git-flow.adoc' => '_output/git-flow/',
    '_articles/rspec-fail-fast/rspec-fail-fast.adoc' => '_output/rspec-fail-fast/',
    '_articles/git-rebase/git-rebase.adoc' => '_output/git-rebase/',
    '_articles/ruby-method-chaining/ruby-method-chaining.adoc' => '_output/ruby-method-chaining/',
    '_articles/fuubar-rspec-progress-bar-formatter/fuubar.adoc' => '_output/fuubar-rspec-progress-bar-formatter/',
    '_articles/ruby-compare-images/ruby-compare-images.adoc' => '_output/ruby-compare-images/',
    '_articles/vim-number/vim-number.adoc' => '_output/vim-number/',
    '_articles/git-git/git-git.adoc' => '_output/git-git/',
    '_articles/mix-proper/mix-proper.adoc' => '_output/mix-proper/',
    '_articles/open-source-maintainability/index.adoc' => '_output/open-source-maintainability/',
    '_articles/vim-reformat-dates/vim-reformat-dates.adoc' => '_output/vim-reformat-dates/',
  }.each do |from, to|
    {
      'amp' => 'amp.html',
      'html5' => 'index.html',
      'atom' => 'atom.xml'
    }.each do |template, filename|
      Asciidoctor.convert_file(
        from,
        {
          backend: "html5s",
          mkdirs: true,
          to_file: "#{to}/#{filename}",
          template_dirs: ["_layouts/html5", "_layouts/#{template}"],
          safe: 0,
          header_footer: true,
          attributes: {
            "experimental" => '',
            "idprefix" => '',
            "idseparator" => '-',
            "asset-dir-key" => "url"
          }
        }
      )
    end
  end
end

task :bundle do
  `cat enough.css/enough.min.css blog.css ad.css | csso -o style.css`
end

task :syndicate do
  template = File.read("feed.xml.erb")
  result = ERB.new(template).result()
  file = File.new("_output/feed.xml", "w")
  file.write(result)
end

task :copy do
  `cp _articles/vim-reformat-dates/substitute-dark.png _output/vim-reformat-dates/substitute-dark.png`
  `cp _articles/vim-reformat-dates/substitute-dark-shadow.png _output/vim-reformat-dates/substitute-dark-shadow.png`
end

task :optimize do
  command("imageoptim _output/vim-reformat-dates/substitute-dark-720px.png")
  command("imageoptim _output/vim-reformat-dates/substitute-dark.png")
end

task :sitemap do
  articles = %w(vim-reformat-dates open-source-maintainability).map do |name|
    filename = Dir.glob("_articles/#{name}/*.adoc").first
    [name, File.mtime(filename).to_date]
  end

  contents = %(<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://jeffkreeftmeijer.com/</loc>
    <lastmod>2017-09-10</lastmod>
    <changefreq>daily</changefreq>
    <priority>1</priority>
  </url>

#{articles.map do |name, mdate|
  "  <url>
    <loc>https://jeffkreeftmeijer.com/#{name}/</loc>
    <lastmod>#{mdate}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>"
end.join("\n\n")}

  <url>
    <loc>https://jeffkreeftmeijer.com/mix-proper/</loc>
    <lastmod>2017-08-22</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/git-flow/</loc>
    <lastmod>2017-08-26</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/git-git/</loc>
    <lastmod>2017-09-10</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/carrierwave-rails-test-fixtures/</loc>
    <lastmod>2017-09-23</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/2014/using-test-fixtures-with-carrierwave/</loc>
    <lastmod>2014-09-09</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2013/on-the-death-of-ifs/</loc>
    <lastmod>2013-04-29</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2012/preloading-dependencies-for-faster-test-suite-start-up-times/</loc>
    <lastmod>2012-06-11</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/vim-number/</loc>
    <lastmod>2017-09-03</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/method-chaining-and-lazy-evaluation-in-ruby/</loc>
    <lastmod>2011-11-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/spec-helpers-bundler-setup-faster-rails-test-suites/</loc>
    <lastmod>2011-10-17</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/microgems-five-minute-rubygems/</loc>
    <lastmod>2011-10-03</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/isolated-testing-for-custom-validators-in-rails-3/</loc>
    <lastmod>2011-09-19</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/vim-is-hard-i-just-want-to-click-around/</loc>
    <lastmod>2011-09-05</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/the-pain-of-json-api-testing/</loc>
    <lastmod>2011-07-25</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/lets-settle-this-in-a-ruby-programming-contest/</loc>
    <lastmod>2011-06-27</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/euruko-the-small-and-informal-european-ruby-conference/</loc>
    <lastmod>2011-06-07</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/managing-herokus-workers-with-hirefire/</loc>
    <lastmod>2011-05-25</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/introducing-tapir-simple-search-for-static-sites/</loc>
    <lastmod>2011-05-09</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/comparing-images-and-creating-image-diffs/</loc>
    <lastmod>2011-04-18</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/pure-ruby-colored-blob-detection/</loc>
    <lastmod>2011-04-11</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/keeping-up-with-the-rails-lighthouse/</loc>
    <lastmod>2011-02-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/acceptance-testing-using-capybaras-new-rspec-dsl/</loc>
    <lastmod>2011-02-21</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/capybara-ate-swinger/</loc>
    <lastmod>2011-02-07</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/herbivore-carnivore/</loc>
    <lastmod>2011-01-31</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/testing-code-thats-testing-itself/</loc>
    <lastmod>2011-01-24</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2011/stop-releasing-prototypes/</loc>
    <lastmod>2011-01-17</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/stillmaintained-status-buttons-in-github-search-results/</loc>
    <lastmod>2010-12-20</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/stillmaintained-is-still-being-maintained/</loc>
    <lastmod>2010-12-13</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/finally-a-way-to-mark-your-github-project-as-abandoned/</loc>
    <lastmod>2010-11-29</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/fuubar-on-spec-13x-cucumber-minitest/</loc>
    <lastmod>2010-11-22</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/ever-heard-of-capybaras-save_and_open_page-method/</loc>
    <lastmod>2010-11-18</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/fuubar-rspec-progress-bar-formatter/</loc>
    <lastmod>2018-06-09</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/rspec-fail-fast/</loc>
    <lastmod>2018-05-23</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/giving-back-to-the-community-the-start-of-the-social-charity-collective/</loc>
    <lastmod>2010-11-05</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/capybara-driver-swapping-on-rspec-with-swinger/</loc>
    <lastmod>2010-11-01</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/rubyandrails-2010/</loc>
    <lastmod>2010-10-25</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/be-awesome-write-your-gemspec-yourself/</loc>
    <lastmod>2010-10-18</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/git-rebase/</loc>
    <lastmod>2018-05-23</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/lets-not-add_bundler_dependencies-anymore/</loc>
    <lastmod>2010-09-27</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/terminitor-the-terminal-automator-from-the-future/</loc>
    <lastmod>2010-09-20</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/disabling-activemodel-callbacks/</loc>
    <lastmod>2010-09-13</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/clients-writing-cucumber-stories/</loc>
    <lastmod>2010-09-07</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/the-mighty-reflog-and-the-amazing-bisect/</loc>
    <lastmod>2010-08-30</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/git-your-act-together/</loc>
    <lastmod>2010-08-23</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/bundler-because-your-gems-depend-on-gems-too/</loc>
    <lastmod>2010-08-16</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/node-js-web-sockets-and-talking-mice/</loc>
    <lastmod>2010-08-09</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/things-i-learned-from-my-node.js-experiment/</loc>
    <lastmod>2010-08-03</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/experimenting-with-node-js/</loc>
    <lastmod>2010-07-26</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/abandoned-open-source-projects/</loc>
    <lastmod>2010-07-19</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/stop-hacking-start-fixing/</loc>
    <lastmod>2010-07-12</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/stumbling-into-vim/</loc>
    <lastmod>2010-07-06</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/finally-releasing-navvy-03/</loc>
    <lastmod>2010-06-28</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/railsconf-2010/</loc>
    <lastmod>2010-06-14</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/daemonizing-navvy-with-god/</loc>
    <lastmod>2010-05-31</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/rise-of-the-navvy/</loc>
    <lastmod>2010-05-24</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/i-bugmashed/</loc>
    <lastmod>2010-05-19</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/setting-up-mongodb-mongomapper-gridfs-devise-carrierwave-on-osx/</loc>
    <lastmod>2010-05-17</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/testing-your-machinist-blueprints/</loc>
    <lastmod>2010-05-10</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/steak-because-cucumber-is-for-vegetarians/</loc>
    <lastmod>2010-05-03</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/making-machinist-master-mongomapper-mongoid/</loc>
    <lastmod>2010-04-26</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/authenticating-via-github-with-guestlist/</loc>
    <lastmod>2010-04-19</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/simple-authentication-with-warden/</loc>
    <lastmod>2010-04-13</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/dont-put-your-gemspec-in-your-rakefile/</loc>
    <lastmod>2010-04-03</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/gitignore-your-gemspec/</loc>
    <lastmod>2010-04-02</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

  <url>
    <loc>https://jeffkreeftmeijer.com/2010/dude-whats-up-with-this-background-image/</loc>
    <lastmod>2010-03-27</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>

</urlset>
)
  File.write('_output/sitemap.xml', contents)
end
