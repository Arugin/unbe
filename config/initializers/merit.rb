#encoding: utf-8
# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  config.orm = :mongoid

  # Add application observers to get notifications when reputation changes.
  config.add_observer 'ReputationChangeObserver'

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
      custom_fields: { category: :activity, difficulty: :bronze, icon: 'fa fa-star' }
   }, {
      id: (badge_id = badge_id + 1),
      name: 'RAFFLE_WINNER',
      description: 'RAFFLE_WINNER_DESC',
      custom_fields: { category: :activity, difficulty: :gold, icon: 'fa fa-star-o' }
   }, {
      id: (badge_id = badge_id + 1),
      name: 'COMMUNICABLE',
      description: 'COMMUNICABLE_DESC',
      level: 1,
      custom_fields: { category: :activity, difficulty: :bronze, icon: 'fa fa-book' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'COMMENTATOR_1',
       description: 'COMMENTATOR_1_DESC',
       level: 1,
       custom_fields: { category: :comments, difficulty: :bronze, icon: 'fa fa-comment' }
   } , {
       id: (badge_id = badge_id + 1),
       name: 'COMMENTATOR_2',
       description: 'COMMENTATOR_2_DESC',
       level: 2,
       custom_fields: { category: :comments, difficulty: :copper, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'COMMENTATOR_3',
       description: 'COMMENTATOR_3_DESC',
       level: 3,
       custom_fields: { category: :comments, difficulty: :silver, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'COMMENTATOR_4',
       description: 'COMMENTATOR_4_DESC',
       level: 4,
       custom_fields: { category: :comments, difficulty: :gold, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'COMMENTATOR_5',
       description: 'COMMENTATOR_5_DESC',
       level: 5,
       custom_fields: { category: :comments, difficulty: :platinum, icon: 'fa fa-comment' }
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
   }, {
       id: (badge_id = badge_id + 1),
       name: 'WRITER_1',
       description: 'WRITER_1_DESC',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'WRITER_2',
       description: 'WRITER_2_DESC',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'WRITER_3',
       description: 'WRITER_3_DESC',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'WRITER_4',
       description: 'WRITER_4_DESC',
       level: 4,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'WRITER_5',
       description: 'WRITER_5_DESC',
       level: 5,
       custom_fields: { category: :articles, difficulty: :platinum, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'RATED_ARTICLE_1',
       description: 'RATED_ARTICLE_1_DESC',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'RATED_ARTICLE_2',
       description: 'RATED_ARTICLE_2_DESC',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'RATED_ARTICLE_3',
       description: 'RATED_ARTICLE_3_DESC',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'RATED_ARTICLE_4',
       description: 'RATED_ARTICLE_4_DESC',
       level: 4,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'RATED_ARTICLE_5',
       description: 'RATED_ARTICLE_5_DESC',
       level: 5,
       custom_fields: { category: :articles, difficulty: :platinum, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'HOLIVAR_1',
       description: 'HOLIVAR_1_DESC',
       level: 1,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-bell' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'HOLIVAR_2',
       description: 'HOLIVAR_2_DESC',
       level: 2,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-bell' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'HOLIVAR_3',
       description: 'HOLIVAR_3_DESC',
       level: 3,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-bell' }
   }, {
      id: (badge_id = badge_id + 1),
      name: 'PART_OF_WHOLE',
      description: 'PART_OF_WHOLE_DESC',
      custom_fields: { category: :common, difficulty: :bronze, icon: 'fa fa-apple' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'ARTICLE_VIEWS_1',
       description: 'ARTICLE_VIEWS_1_DESC',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-eye' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'ARTICLE_VIEWS_2',
       description: 'ARTICLE_VIEWS_2_DESC',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-eye' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'ARTICLE_VIEWS_3',
       description: 'ARTICLE_VIEWS_3_DESC',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-eye' }
   }
 ].each do |attrs|
   Merit::Badge.create! attrs
end