require "bundler/capistrano"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "unbe"
set :repository,  "https://github.com/Arugin/unberails.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :deploy_to, "/home/arugin/webapps/unbe/"
set :default_stage, "production"

role :web, "web441.webfaction.com"                          # Your HTTP server, Apache/etc
role :app, "web441.webfaction.com"                          # This may be the same as your `Web` server
role :db,  "web441.webfaction.com", :primary => true        # This is where Rails migrations will run

set :default_shell, "bash -l"

set :user, "arugin"
set :scm_username, "Arugin"
set :use_sudo, false
set :deploy_via, :checkout
set :branch, "master"

set :keep_releases, 4

set :default_environment, {
    'PATH' => "#{deploy_to}/bin:$PATH",
    'GEM_HOME' => "#{deploy_to}/gems",
    'RAILS_ENV' => "#{default_stage}"
}

desc "Restart nginx"
task :restart do
  run "#{deploy_to}/bin/restart"
end

desc "Start nginx"
task :start do
  run "#{deploy_to}/bin/start"
end

desc "Stop nginx"
task :stop do
  run "#{deploy_to}/bin/stop"
end

desc "Logs"
task :logs do
  run "cd #{deploy_to}/current; rm -rf log; mkdir log"
end

namespace :deploy do
  puts "============================================="
  puts "SIT BACK AND RELAX WHILE CAPISTRANO ROCKS ON!"
  puts "============================================="

  desc "Seed database"
  task :remakedb do
    run "cd #{deploy_to}/current; bundle exec rake db:migrate RAILS_ENV=#{default_stage}"
    run "cd #{deploy_to}/current; bundle exec rake db:seed RAILS_ENV=#{default_stage}"
  end

  desc "Seed database"
  task :seed do
    run "cd #{deploy_to}/current; bundle exec rake db:seed RAILS_ENV=#{default_stage}"
  end

  desc "Migrate database"
  task :migrate do
    run "cd #{deploy_to}/current; bundle exec rake db:migrate RAILS_ENV=#{default_stage}"
  end

  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile, :roles => :web, :except => { :no_release => true } do
      run "cd #{deploy_to}/current; bundle exec rake assets:precompile"
    end
  end
end

after "deploy", "logs"
after "deploy", "deploy:assets:precompile"
after "deploy", "deploy:migrate"
after "deploy", "restart"