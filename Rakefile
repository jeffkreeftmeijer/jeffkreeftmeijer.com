require 'aws-sdk'
require 'yaml'
require 'pathname'
require 'dracula'

task :generate do
  `rm -rf _output`
  Dracula::Generator.new(File.dirname(__FILE__)).generate
end

desc "Package stylesheets into style.css"
task :pack_stylesheets do
  File.open('css/style.css', 'w') do |f|
    Dir.glob('css/*').map { |p| File.read(p) }.join("\n").tap do |output|
      f.write output
    end
  end
end

desc "Upload to S3"
task :upload do
  load 'env.rb'

  service = AWS::S3.new(
    :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
  )

  output_directory = Pathname.new('_output')
  files = Dir["#{output_directory }/**/*"].reject { |file| File.directory?(file) }
  bucket = service.buckets["jeffkreeftmeijer.com"]

  files.each do |file|
    pathname = Pathname.new(file).relative_path_from(output_directory)

    options = {:acl => :public_read}
    options[:content_type] = 'text/html' if File.extname(file) == '.html'

    if pathname.to_s == 'feed.xml'
      options[:website_redirect_location] = 'http://feedpress.me/jeffkreeftmeijer'
    end

    puts "Uploading #{pathname} with options: #{options}..."
    bucket.objects[pathname].write(File.read(file), options)
  end
end

task update: [:pack_stylesheets, :generate, :upload]
