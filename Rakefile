require 'asciidoctor'
require 'asciidoctor-html5s'
require 'erb'

task :generate => [:bundle, :build]

task :build do
  {
    '_articles/git-flow/git-flow.adoc' => '_output/git-flow/',
    '_articles/rspec-fail-fast/rspec-fail-fast.adoc' => '_output/rspec-fail-fast/',
    '_articles/git-rebase/git-rebase.adoc' => '_output/git-rebase/',
    '_articles/ruby-method-chaining/ruby-method-chaining.adoc' => '_output/ruby-method-chaining/',
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
            "tip-caption" => '💡',
            "warning-caption" => '⚠️',
            "note-caption" => 'ℹ️',
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
