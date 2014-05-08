# Be sure to restart your server when you modify this file.
#
# 5 stars is a common ranking use case. They are not given at specified
# actions like badges, you should define a cron job to test if ranks are to be
# granted.
#
# +set_rank+ accepts:
# * :+level+ ranking level (greater is better)
# * :+to+ model or scope to check if new rankings apply
# * :+level_name+ attribute name (default is empty and results in 'level'
#   attribute, if set it's appended like 'level_#{level_name}')

module Merit
  class RankRules
    include Merit::RankRulesMethods

    def initialize
      set_rank level: 1, to: User.active do |user|
       user.points >= Utils.RANKS[1]
      end

      set_rank level: 2, to: User.active do |user|
       user.points >= Utils.RANKS[2]
      end

      set_rank level: 3, to: User.active do |user|
       user.points >= Utils.RANKS[3]
      end

      set_rank level: 4, to: User.active do |user|
        user.points >= Utils.RANKS[4]
      end

      set_rank level: 5, to: User.active do |user|
        user.points >= Utils.RANKS[5]
      end

      set_rank level: 6, to: User.active do |user|
        user.points >= Utils.RANKS[6]
      end
    end
  end
end