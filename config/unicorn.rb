# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_path = File.expand_path(File.dirname(__FILE__) + '/..')

# The number of worker processes you have here should equal the number of CPU
# cores your server has.
worker_processes (ENV['RAILS_ENV'] == 'production' ? 4 : 1)

# You can listen on a port or a socket. Listening on a socket is good in a
# production environment, but listening on a port can be useful for local
# debugging purposes.
listen '/var/run/unicorn/unicorn.sock', backlog: 64

# After the timeout is exhausted, the unicorn worker will be killed and a new
# one brought up in its place. Adjust this to your application's needs. The
# default timeout is 60. Anything under 3 seconds won't work properly.
timeout 300

# Set the working directory of this unicorn instance.
working_directory app_path

# Set the location of the unicorn pid file. This should match what we put in the
# unicorn init script later.
pid '/var/run/unicorn/unicorn.pid'

# You should define your stderr and stdout here. If you don't, stderr defaults
# to /dev/null and you'll lose any error logging when in daemon mode.
stderr_path '/var/log/unicorn/unicorn.log'
stdout_path '/var/log/unicorn/unicorn.log'

# Load the app up before forking.
preload_app true

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
