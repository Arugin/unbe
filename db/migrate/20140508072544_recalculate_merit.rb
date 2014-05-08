class RecalculateMerit < Mongoid::Migration
  def self.up
    # 1. Reset all badges/points granting
    Merit::BadgesSash.delete_all
    Merit::Score::Point.delete_all

    # 1.1 Optionally reset activity log (badges/points granted/removed until now)
    Merit::ActivityLog.delete_all

    # 2. Mark all `merit_actions` as unprocessed
    Merit::Action.all.map{|a| a.update_attribute :processed, false }

    # 3. Recompute reputation rules
    Merit::Action.check_unprocessed
    Merit::RankRules.new.check_rank_rules
  end

  def self.down
  end
end