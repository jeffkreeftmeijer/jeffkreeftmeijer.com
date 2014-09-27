require 'aws-sdk'
require 'yaml'
require 'pathname'
require 'dracula'
require 'yui/compressor'
require 'html_press'

task :generate do
  `rm -rf _output`
  Dracula::Generator.new(File.dirname(__FILE__)).generate
end

desc "Update analytics javascripts"
task :update_analytics do
  `curl http://google-analytics.com/analytics.js -o js/analytics.js`
end

desc "Compress HTML"
task :compress_html do
  output_directory = Pathname.new('_output')
  files = Dir["#{output_directory }/**/*"].reject { |file| File.directory?(file) }

  files.each do |file|
    if File.extname(file) == '.html'
      puts "Compressing #{file}..."
      contents = HtmlPress.press File.read(file)
      File.open(file, 'w') { |f| f.write contents }
    end
  end
end

desc "Package stylesheets into style.css"
task :pack_stylesheets do
  File.open('css/style.css', 'w') do |f|
    Dir.glob('css/*').map { |p| File.read(p) }.join("\n").tap do |output|
      f.write output
    end
  end
end

desc "GZip html, css and javascript files"
task :gzip do
  output_directory = Pathname.new('_output')
  files = Dir["#{output_directory }/**/*"].reject { |file| File.directory?(file) }

  files.each do |file|
    if ['.html', '.css', '.js'].include? File.extname(file)
      puts "GZipping #{file}..."
      `gzip -9 #{file} && mv #{file}.gz #{file}`
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

    if pathname.to_s == 'comments/index.html'
      options[:website_redirect_location] = 'http://jeffkreeftmeijer.com'
    end

    if ['.html', '.css', '.js'].include? File.extname(file)
      options[:content_encoding] = 'gzip'
    end

    puts "Uploading #{pathname} with options: #{options}..."
    bucket.objects[pathname].write(File.read(file), options)
  end
end

task update: [:update_analytics, :pack_stylesheets, :generate, :gzip, :upload]
