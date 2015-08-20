require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/unicorn'

set :domain, '10.0.3.80'
set :deploy_to, '/opt/app/katuma'
set :repository, 'https://github.com/coopdevs/katuma.git'
set :branch, 'develop'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']

# Unicorn stuff
set :unicorn_pid, '/var/run/unicorn/unicorn.pid'

# Optional settings:
set :user, 'katuma'
# set :port, '30000'     # SSH port number.
set :forward_agent, true

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # Loads katuma environment variables
  queue '. /etc/default/katuma'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'unicorn:restart'
    end
  end
end
