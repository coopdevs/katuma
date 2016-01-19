namespace :sidekiq do
  desc "Starts Sidekiq init.d script"
  task :start => :environment do
    queue "sudo /etc/init.d/sidekiq_katuma start"
  end

  desc "Stops Sidekiq init.d script"
  task :stop => :environment do
    queue "sudo /etc/init.d/sidekiq_katuma stop"
  end

  desc "Restarts Sidekiq init.d script"
  task :restart => :environment do
    queue "sudo /etc/init.d/sidekiq_katuma restart"
  end
end
