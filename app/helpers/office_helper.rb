module OfficeHelper
  def to_next_rank(user)
    if Utils.RANKS[user.level+1].present?
      (user.points/Utils.RANKS[user.level+1].to_f)*100
    else
      0
    end
  end

  def to_next_rank_exp(user)
    if Utils.RANKS[user.level+1].present?
      Utils.RANKS[user.level+1] - Utils.RANKS[user.level]
    else
      t :NEXT_RANK_NOT_EXISTS
    end
  end
end
