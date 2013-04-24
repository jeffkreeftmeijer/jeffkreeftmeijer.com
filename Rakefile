require "yui/compressor"
require 'aws-sdk'
require 'yaml'
require 'pathname'

desc "Package stylesheets into style.css"
task :pack_stylesheets do
  File.open('css/style.css', 'w') do |f|
    Dir.glob('css/*').map { |p| File.read(p) }.join("\n").tap do |output|
      f.write YUI::CssCompressor.new.compress(output)
    end
  end
end

desc "Upload to S3"
task :update do
  puts `rake pack_stylesheets`
  puts `jekyll --pygments`

  config = YAML.load_file('s3.yml')

  service = AWS::S3.new(
    :access_key_id     => config['access_key_id'],
    :secret_access_key => config['secret_access_key']
  )

  output_directory = Pathname.new('_site')
  files = Dir["#{output_directory }/**/*"].reject { |file| File.directory?(file) }
  bucket = service.buckets["jeffkreeftmeijer.com"]

  files.each do |file|
    pathname = Pathname.new(file).relative_path_from(output_directory)
    puts "Uploading #{pathname}..."

    options = {:acl => :public_read}
    options[:content_type] = 'text/html' if File.extname(file) == '.html'
    bucket.objects[pathname].write(File.read(file), options)
  end
end
