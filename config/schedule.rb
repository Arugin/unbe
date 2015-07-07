set :output, '/home/ec2-user/unbe/file.log'

job_type :rake, "cd :path && :environment_variable=:environment rake :task --silent :output"

every :friday, at: '8pm' do
  rake  "mail:last_articles"
end

every :day, at: '5am' do
  rake  "update_ranks"
end