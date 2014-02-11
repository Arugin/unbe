APPS = [
    { remote: 'heroku', name: 'unbe' },
    { remote: 'cdn0',   name: 'unbe-cdn0' },
    { remote: 'cdn1',   name: 'unbe-cdn1' },
]

desc "Deploys the full app."
multitask deploy: APPS.map { |app| "deploy:#{app[:remote]}" }

namespace :deploy do
  APPS.each do |app|
    desc "Deploys to #{app[:remote]}"
    task app[:remote] => "deploy:#{app[:remote]}:push"

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

  desc 'Run migrations on every server'
  multitask migrate: APPS.map { |app| "deploy:#{app[:remote]}:migrate" }
end