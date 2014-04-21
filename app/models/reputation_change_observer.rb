class ReputationChangeObserver
  def update(changed_data)
    # description will be something like:
    #   granted 5 points
    #   granted just-registered badge
    #   removed autobiographer badge
    description = changed_data[:description]

    # If user is your meritable model, you can grab it like:
    if changed_data[:merit_object] && changed_data[:merit_object].respond_to?(:activity_logs)
      sash_id = changed_data[:merit_object].sash_id
      user = User.where(sash_id: sash_id).first
      user.create_activity action: :reputation_change, owner: user, params: {description: description}
    end

    # To know where and when it happened:
    merit_action = Merit::Action.find changed_data[:merit_action_id]
    #controller = merit_action.target_model
    #action = merit_action.action_method
    #when_happend = merit_action.created_at
  end
end