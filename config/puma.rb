workers 1

# Min and Max threads per worker
threads 1, 1

app_dir = File.expand_path('../..', __FILE__)
shared_dir = "#{app_dir}/tmp"

# Default to production
rails_env = ENV['RAILS_ENV'] || 'production'
environment rails_env

bind 'unix:/tmp/unbe.sock'
# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

activate_control_app
