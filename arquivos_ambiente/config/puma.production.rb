# Change to match your CPU core count
workers 2
worker_timeout 120
# Fix for deploy with large number of CPUs (workers)
worker_boot_timeout 120

# Min and Max threads per worker
threads 6, 9

app_dir = "/srv/decide"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{app_dir}/tmp/sockets/puma.sock"

# Set the socket file permissions and group
activate_control_app
shared_group = 'nginx'

before_fork do
  File.umask(0777) # Allow group read/write
end

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  #ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end

after_worker_boot do
  # require 'etc'
  
  # socket_path = "#{app_dir}/tmp/sockets/puma.sock"
  
  # nginx_uid = Etc.getpwnam('nginx').uid
  # decide_gid = Etc.getgrnam('decide').gid
  
  # File.chown(nginx_uid, decide_gid, socket_path)
  # File.chown('nginx', 'decide', "#{app_dir}/tmp/sockets/puma.sock")
  File.chown(Etc.getgrnam(shared_group).gid, nil, '/srv/decide/tmp/sockets/puma.sock')


end