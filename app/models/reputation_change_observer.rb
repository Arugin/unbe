class ReputationChangeObserver
  def update(changed_data)
    description = changed_data[:description]

    if changed_data[:merit_object] && changed_data[:merit_object].respond_to?(:activity_logs) && changed_data[:merit_object].kind_of?(Merit::BadgesSash)
      sash_id = changed_data[:merit_object].sash_id
      user = User.where(sash_id: sash_id).first
      user.create_activity action: :reputation_change, owner: user, params: {description: description}
    end
    merit_action = Merit::Action.find changed_data[:merit_action_id]
  end
end