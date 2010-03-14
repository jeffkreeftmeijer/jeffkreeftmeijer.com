desc 'update site from remote repo'
task :update do
  require 'rubygems'
  require 'net/ssh'

  Net::SSH.start('208.88.125.96', 'jeff') do |ssh|
    ssh.exec("cd jeffkreeftmeijer.com && git pull origin master && jekyll")
  end  
end
