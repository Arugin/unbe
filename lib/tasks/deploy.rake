APPS = [
    { remote: 'heroku', name: 'unbe' },
    { remote: 'cdn0',   name: 'unbe-cdn0' },
    { remote: 'cdn1',   name: 'unbe-cdn1' },
]

def deploy_app(action = 'push')
  APPS.each do |app|
    desc "Deploys to #{app[:remote]}"
    task app[:remote] => "deploy:#{app[:remote]}:#{action}"

    namespace app[:remote] do
      task :push do
        puts "Pushing to #{app[:remote]}"
        puts `git push #{app[:remote]} master`
      end

      task :force_push do
        puts "Pushing to #{app[:remote]}"
        puts `git push -f #{app[:remote]} master`
      end

      task :migrate do
        puts "Migrating #{app[:name]}"
        puts `heroku run rake db:migrate --app #{app[:name]}`
      end
    end
  end
end

desc "Deploys the full app."
multitask deploy: APPS.map { |app| "deploy:#{app[:remote]}" }
multitask force_deploy: APPS.map { |app| "force_deploy:#{app[:remote]}" }

namespace :deploy do
  deploy_app

  desc 'Run migrations on every server'
  multitask migrate: APPS.map { |app| "deploy:#{app[:remote]}:migrate" }
end

namespace :force_deploy do
  deploy_app('force_push')
end

