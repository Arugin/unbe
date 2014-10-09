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
      name: 'badges.raffle_participant.title',
      description: 'badges.raffle_participant.description',
      custom_fields: { category: :activity, difficulty: :bronze, icon: 'fa fa-star' }
   }, {
      id: (badge_id = badge_id + 1),
      name: 'badges.raffle_winner.title',
      description: 'badges.raffle_winner.description',
      custom_fields: { category: :activity, difficulty: :gold, icon: 'fa fa-star-o' }
   }, {
      id: (badge_id = badge_id + 1),
      name: 'badges.communicable.title',
      description: 'badges.communicable.description',
      level: 1,
      custom_fields: { category: :activity, difficulty: :bronze, icon: 'fa fa-book' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.commentator.1.title',
       description: 'badges.commentator.1.description',
       level: 1,
       custom_fields: { category: :comments, difficulty: :bronze, icon: 'fa fa-comment' }
   } , {
       id: (badge_id = badge_id + 1),
       name: 'badges.commentator.2.title',
       description: 'badges.commentator.2.description',
       level: 2,
       custom_fields: { category: :comments, difficulty: :copper, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.commentator.3.title',
       description: 'badges.commentator.3.description',
       level: 3,
       custom_fields: { category: :comments, difficulty: :silver, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.commentator.4.title',
       description: 'badges.commentator.4.description',
       level: 4,
       custom_fields: { category: :comments, difficulty: :gold, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.commentator.5.title',
       description: 'badges.commentator.5.description',
       level: 5,
       custom_fields: { category: :comments, difficulty: :platinum, icon: 'fa fa-comment' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_comment.1.title',
       description: 'badges.rated_comment.1.description',
       level: 1,
       custom_fields: { category: :comments, difficulty: :bronze, icon: 'fa fa-comments-o' }
   } , {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_comment.2.title',
       description: 'badges.rated_comment.2.description',
       level: 2,
       custom_fields: { category: :comments, difficulty: :copper, icon: 'fa fa-comments-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_comment.3.title',
       description: 'badges.rated_comment.3.description',
       level: 3,
       custom_fields: { category: :comments, difficulty: :silver, icon: 'fa fa-comments-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_comment.4.title',
       description: 'badges.rated_comment.4.description',
       level: 4,
       custom_fields: { category: :comments, difficulty: :gold, icon: 'fa fa-comments-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_comment.5.title',
       description: 'badges.rated_comment.5.description',
       level: 5,
       custom_fields: { category: :comments, difficulty: :platinum, icon: 'fa fa-comments-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.writer.1.title',
       description: 'badges.writer.1.description',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.writer.2.title',
       description: 'badges.writer.2.description',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.writer.3.title',
       description: 'badges.writer.3.description',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.writer.4.title',
       description: 'badges.writer.4.description',
       level: 4,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.writer.5.title',
       description: 'badges.writer.5.description',
       level: 5,
       custom_fields: { category: :articles, difficulty: :platinum, icon: 'fa fa-pencil-square-o' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_article.1.title',
       description: 'badges.rated_article.1.description',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_article.2.title',
       description: 'badges.rated_article.2.description',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_article.3.title',
       description: 'badges.rated_article.3.description',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_article.4.title',
       description: 'badges.rated_article.4.description',
       level: 4,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.rated_article.5.title',
       description: 'badges.rated_article.5.description',
       level: 5,
       custom_fields: { category: :articles, difficulty: :platinum, icon: 'fa fa-pencil' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.holivar.1.title',
       description: 'badges.holivar.1.description',
       level: 1,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-bell' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.holivar.2.title',
       description: 'badges.holivar.2.description',
       level: 2,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-bell' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.holivar.3.title',
       description: 'badges.holivar.3.description',
       level: 3,
       custom_fields: { category: :articles, difficulty: :gold, icon: 'fa fa-bell' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.part_of_whole.title',
       description: 'badges.part_of_whole.description',
       custom_fields: { category: :common, difficulty: :bronze, icon: 'fa fa-apple' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.article_views.1.title',
       description: 'badges.article_views.1.description',
       level: 1,
       custom_fields: { category: :articles, difficulty: :bronze, icon: 'fa fa-eye' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.article_views.2.title',
       description: 'badges.article_views.2.description',
       level: 2,
       custom_fields: { category: :articles, difficulty: :copper, icon: 'fa fa-eye' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.article_views.3.title',
       description: 'badges.article_views.3.description',
       level: 3,
       custom_fields: { category: :articles, difficulty: :silver, icon: 'fa fa-eye' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.incredible.title',
       description: 'badges.incredible.description',
       custom_fields: { category: :great, difficulty: :platinum, icon: 'fa fa-question' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.subscribable.1.title',
       description: 'badges.subscribable.1.description',
       level: 1,
       custom_fields: { category: :activity, difficulty: :bronze, icon: 'fa fa-chain' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.subscribable.2.title',
       description: 'badges.subscribable.2.description',
       level: 2,
       custom_fields: { category: :activity, difficulty: :copper, icon: 'fa fa-chain' }
   }, {
       id: (badge_id = badge_id + 1),
       name: 'badges.subscribable.3.title',
       description: 'badges.subscribable.3.description',
       level: 3,
       custom_fields: { category: :activity, difficulty: :silver, icon: 'fa fa-chain' }
   }
 ].each do |attrs|
   Merit::Badge.create! attrs
end