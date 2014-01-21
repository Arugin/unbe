#encoding: utf-8
# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  config.orm = :mongoid

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grand badge if no :to option is given. Default is "User".
  config.user_model_name = "User"

  # Define :current_user_method. Similar to previous option. It will be used to retrieve :user_model_name object if no :to option is given. Default is "current_#{user_model_name.downcase}".
  config.current_user_method = "current_user"
end

# Create application badges (uses https://github.com/norman/ambry)
# difficulty:
#   iron
#   bronze
#   silver
#   gold
#   platinum
 badge_id = 0
 [{
    id: (badge_id = badge_id+1),
    name: 'RAFFLE_PARTICIPANT',
    description: 'RAFFLE_PARTICIPANT_DESC',
    custom_fields: { category: :activity, difficulty: :iron }
 }, {
    id: (badge_id = badge_id+1),
    name: 'RAFFLE_WINNER',
    description: 'RAFFLE_WINNER_DESC',
    custom_fields: { category: :activity, difficulty: :gold }
 }, {
    id: (badge_id = badge_id+1),
    name: 'COMMUNICABLE',
    description: 'COMMUNICABLE_DESC',
    level: 1,
    custom_fields: { category: :users, difficulty: :iron }
  }].each do |attrs|
   Merit::Badge.create! attrs
end