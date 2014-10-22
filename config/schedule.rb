set :output, '/home/arugin/webapps/unbe/file.log'

job_type :rake, "cd :path && :environment_variable=:environment GEM_HOME=$HOME/webapps/unbe/gems RUBY_LIB=$HOME/webapps/unbe/lib PATH=$HOME/webapps/unbe/bin:$PATH rake :task --silent :output"

every :friday, at: '8pm' do
  rake  "mail:last_articles"
end

every :day, at: '5am' do
  rake  "update_ranks"
end