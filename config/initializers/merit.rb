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
#   bronze
#   copper
#   silver
#   gold
#   platinum
 badge_id = 0
 [
 {
    id: (badge_id = badge_id + 1),
    name: 'RAFFLE_PARTICIPANT',
    description: 'RAFFLE_PARTICIPANT_DESC',
    custom_fields: { category: :activity, difficulty: :bronze, icon: 'icon-star-alt' }
 }, {
    id: (badge_id = badge_id + 1),
    name: 'RAFFLE_WINNER',
    description: 'RAFFLE_WINNER_DESC',
    custom_fields: { category: :activity, difficulty: :gold, icon: 'icon-star-empty' }
 }, {
    id: (badge_id = badge_id + 1),
    name: 'COMMUNICABLE',
    description: 'COMMUNICABLE_DESC',
    level: 1,
    custom_fields: { category: :activity, difficulty: :bronze, icon: 'icon-address-book' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'COMMENTATOR_1',
     description: 'COMMENTATOR_1_DESC',
     level: 1,
     custom_fields: { category: :comments, difficulty: :bronze, icon: 'icon-comment' }
 } , {
     id: (badge_id = badge_id + 1),
     name: 'COMMENTATOR_2',
     description: 'COMMENTATOR_2_DESC',
     level: 2,
     custom_fields: { category: :comments, difficulty: :copper, icon: 'icon-comment' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'COMMENTATOR_3',
     description: 'COMMENTATOR_3_DESC',
     level: 3,
     custom_fields: { category: :comments, difficulty: :silver, icon: 'icon-comment' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'COMMENTATOR_4',
     description: 'COMMENTATOR_4_DESC',
     level: 4,
     custom_fields: { category: :comments, difficulty: :gold, icon: 'icon-comment' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'COMMENTATOR_5',
     description: 'COMMENTATOR_5_DESC',
     level: 5,
     custom_fields: { category: :comments, difficulty: :platinum, icon: 'icon-comment' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'RATED_COMMENT_1',
     description: 'RATED_COMMENT_1_DESC',
     level: 1,
     custom_fields: { category: :comments, difficulty: :bronze, icon: 'fa fa-comments-o' }
 } , {
     id: (badge_id = badge_id + 1),
     name: 'RATED_COMMENT_2',
     description: 'RATED_COMMENT_2_DESC',
     level: 2,
     custom_fields: { category: :comments, difficulty: :copper, icon: 'fa fa-comments-o' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'RATED_COMMENT_3',
     description: 'RATED_COMMENT_3_DESC',
     level: 3,
     custom_fields: { category: :comments, difficulty: :silver, icon: 'fa fa-comments-o' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'RATED_COMMENT_4',
     description: 'RATED_COMMENT_4_DESC',
     level: 4,
     custom_fields: { category: :comments, difficulty: :gold, icon: 'fa fa-comments-o' }
 }, {
     id: (badge_id = badge_id + 1),
     name: 'RATED_COMMENT_5',
     description: 'RATED_COMMENT_5_DESC',
     level: 5,
     custom_fields: { category: :comments, difficulty: :platinum, icon: 'fa fa-comments-o' }
 }
 ].each do |attrs|
   Merit::Badge.create! attrs
end