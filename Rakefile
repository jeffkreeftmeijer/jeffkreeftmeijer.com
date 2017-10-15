require 'asciidoctor'

task :generate do
  {
    '_articles/git-flow/git-flow.adoc' => '_output/git-flow/index.html',
    '_articles/open-source-maintainability/index.adoc' => '_output/open-source-maintainability/index.html',
  }.each do |from, to|
    Asciidoctor.convert_file(
      from,
      {
        to_file: to,
        template_dir: '_layouts/html5',
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
