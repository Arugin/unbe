every :friday, :at => '8pm' do
  rake  "mail:last_articles"
end

every :day, :at => '5am' do
  rake  "update_ranks"
end