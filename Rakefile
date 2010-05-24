require 'rubygems'
require 'net/ssh'
require File.expand_path(File.dirname(__FILE__) + '/lib/moby')

desc 'update site from remote repo'
task :update do

 user = 'jeffkreeftmeijer'
 repo = 'jeffkreeftmeijer.com'

 Net::SSH.start('208.88.125.96', 'jeff') do |ssh|
   ssh.exec(
    "rm -rf #{repo} _site && " <<
    "git clone -q git://github.com/#{user}/#{repo}.git && " <<
    "jekyll #{repo} _site --pygments && " <<
    "rake -f #{repo}/Rakefile moby:fetch")
  end
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
