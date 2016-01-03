namespace :unicorn do
  desc "Starts Unicorn init.d script"
  task :start => :environment do
    queue "sudo /etc/init.d/unicorn_katuma start"
  end

  desc "Stops Unicorn init.d script"
  task :stop => :environment do
    queue "sudo /etc/init.d/unicorn_katuma stop"
  end

  desc "Restarts Unicorn init.d script"
  task :restart => :environment do
    queue "sudo /etc/init.d/unicorn_katuma restart"
  end
end
