# config valid only for current version of Capistrano
lock '3.4.0'

set :rbenv_ruby, '2.2.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails eye whenever}

set :application, 'unbe'
set :repo_url, 'https://github.com/Arugin/unberails.git'

set :deploy_to, '/home/ec2-user/unbe'
set :format, :pretty
set :default_shell, "bash -l"
set :rails_env, 'production'

set :eye_application, 'unbe'
set :eye_config, '/home/ec2-user/unbe/current/unbe.eye'

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

namespace :deploy do
  desc "Update crontab with whenever"
  task :update_cron do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
      end
    end
  end

  after :finishing, 'deploy:update_cron'
end
