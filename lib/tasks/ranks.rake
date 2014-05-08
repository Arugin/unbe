desc "Check and grant ranks"
task update_ranks: :environment do
  puts "Checking ranks..."
  Merit::RankRules.new.check_rank_rules
  puts "done."
end