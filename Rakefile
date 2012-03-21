require 'rubygems'
require 'net/ssh'
require "yui/compressor"
require File.expand_path(File.dirname(__FILE__) + '/lib/moby')

desc 'update site from remote repo'
task :update do
  puts `jekyll --pygments && rsync -r _site/* 204.62.15.98:_site`
end

desc "Package stylesheets into style.css"
task :pack_stylesheets do
  File.open('css/style.css', 'w') do |f|
    Dir.glob('css/*').map { |p| File.read(p) }.join("\n").tap do |output|
      f.write YUI::CssCompressor.new.compress(output)
    end
  end
end
