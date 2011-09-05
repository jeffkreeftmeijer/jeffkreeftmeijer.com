require 'rubygems'
require 'net/ssh'
require File.expand_path(File.dirname(__FILE__) + '/lib/moby')

desc 'update site from remote repo'
task :update do
  puts `jekyll --pygments && rsync -r _site/* 204.62.15.98:_site`
end

namespace :moby do
  desc 'fetch the newest image from mobypicture'
  task :fetch do
    Moby.fetch
  end

  desc 'fetch the newest image every fifteen minutes'
  task :loop do
    loop { Moby.fetch; sleep 900 }
  end
end