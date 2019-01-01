require 'asciidoctor'
require 'asciidoctor-html5s'
require 'erb'
require 'date'

def command(command)
  puts command
  puts `#{command}`
end

task :generate => [:bundle, :copy, :build, :sitemap, :resample]

task :build do
  {
    '_articles/git-flow/git-flow.adoc' => '_output/git-flow/',
    '_articles/rspec-fail-fast/rspec-fail-fast.adoc' => '_output/rspec-fail-fast/',
    '_articles/git-rebase/git-rebase.adoc' => '_output/git-rebase/',
    '_articles/ruby-method-chaining/ruby-method-chaining.adoc' => '_output/ruby-method-chaining/',
    '_articles/fuubar-rspec-progress-bar-formatter/fuubar.adoc' => '_output/fuubar-rspec-progress-bar-formatter/',
    '_articles/ruby-compare-images/ruby-compare-images.adoc' => '_output/ruby-compare-images/',
    '_articles/vim-number/vim-number.adoc' => '_output/vim-number/',
    '_articles/carrierwave-rails-test-fixtures/carrierwave-rails-test-fixtures.adoc' => '_output/carrierwave-rails-test-fixtures/',
    '_articles/activerecord-destroyed/activerecord-destroyed.adoc' => '_output/activerecord-destroyed/',
    '_articles/git-git/git-git.adoc' => '_output/git-git/',
    '_articles/mix-proper/mix-proper.adoc' => '_output/mix-proper/',
    '_articles/open-source-maintainability/index.adoc' => '_output/open-source-maintainability/',
    '_articles/vim-reformat-dates/vim-reformat-dates.adoc' => '_output/vim-reformat-dates/',
    '_articles/vim-16-color/vim-16-color.adoc' => '_output/vim-16-color/',
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
  `cat enough.css/enough.css enough.css/enough.media.css enough.css/enough.code.css enough.css/enough.table.css blog.css ad.css | node_modules/.bin/cssnano > style.css`
end

task :syndicate do
  template = File.read("feed.xml.erb")
  result = ERB.new(template).result()
  file = File.new("_output/feed.xml", "w")
  file.write(result)
end

task :copy do
  command("cp _articles/git-rebase/*.svg _output/git-rebase/")
  `cp _articles/vim-reformat-dates/substitute-dark.png _output/vim-reformat-dates/substitute-dark.png`
  `cp _articles/vim-reformat-dates/substitute-dark-shadow.png _output/vim-reformat-dates/substitute-dark-shadow.png`
  command("cp _articles/vim-16-color/*.png _output/vim-16-color/")
end

task :resample do
  command("sips --resampleWidth 1540 _output/vim-16-color/split.png")
  command("sips --resampleWidth 1540 _output/vim-16-color/compare.png")
  command("sips --resampleWidth 1540 _output/vim-16-color/picker.png")
end

task :optimize do
  command("imageoptim _output/vim-reformat-dates/substitute-dark-720px.png")
  command("imageoptim _output/vim-reformat-dates/substitute-dark.png")
  command("imageoptim _output/vim-16-color/*.png")
end

task :sitemap do
  articles = %w(
    vim-16-color vim-reformat-dates open-source-maintainability mix-proper
    git-flow git-git carrierwave-rails-test-fixtures vim-number
    activerecord-destroyed ruby-method-chaining ruby-compare-images
    fuubar-rspec-progress-bar-formatter rspec-fail-fast git-rebase
  ).map do |name|
    filename = Dir.glob("_articles/#{name}/*.{adoc,md}").first
    [name, File.mtime(filename).to_date]
  end

  template = File.read("sitemap.xml.erb")
  result = ERB.new(template).result(binding)
  File.write('_output/sitemap.xml', result)
end
