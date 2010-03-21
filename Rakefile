require 'rubygems'
require 'net/ssh'
require 'lib/moby'

desc 'update site from remote repo'
task :update do
  Net::SSH.start('208.88.125.96', 'jeff') do |ssh|
    ssh.exec("cd jeffkreeftmeijer.com && git pull origin master && jekyll")
  end
end

namespace :moby do
  desc 'fetch the newest image from mobypicture'
  task :fetch do
    Moby.fetch
  end
  
  desc 'fetch the newest image from mobypicture every fifteen minutes'
  task :loop do
    loop { Moby.fetch; sleep 900 }
  end
end
