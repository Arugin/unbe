# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+:votes => 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.
      # grant_on 'users#create', :badge => 'just-registered', :to => :itself

      # If it has 10 comments, grant commenter-10 badge
      # grant_on 'comments#create', :badge => 'commenter', :level => 10 do |comment|
      #   comment.user.comments.count == 10
      # end

      # If it has 5 votes, grant relevant-commenter badge
      # grant_on 'comments#vote', :badge => 'relevant-commenter', :to => :user do |comment|
      #   comment.votes.count == 5
      # end

      grant_on 'users#update', badge: 'COMMUNICABLE', temporary: true do |user|
        user.full_profile?
      end

      grant_on ['articles#create'], badge: 'PART_OF_WHOLE', to: :author do |subject|
        subject.author.full_actions?
      end

      grant_on ['contents#create'], model_name: 'Content::BaseContent', badge: 'PART_OF_WHOLE', to: :author do |subject|
        subject.author.full_actions?
      end

      grant_on 'comments#create', badge: 'PART_OF_WHOLE', to: :user do |comment|
        comment.user.full_actions?
      end

      grant_on 'comments#vote_up', badge: 'COMMENTATOR_1', level: 1, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_point >= 1 }.count >= 25
      end

      grant_on 'comments#vote_up', badge: 'COMMENTATOR_2', level: 2, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_point >= 1 }.count >= 100
      end

      grant_on 'comments#vote_up', badge: 'COMMENTATOR_3', level: 3, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_point >= 1 }.count >= 400
      end

      grant_on 'comments#vote_up', badge: 'COMMENTATOR_4', level: 4, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_point >= 1 }.count >= 2000
      end

      grant_on 'comments#vote_up', badge: 'COMMENTATOR_5', level: 5, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_point >= 1 }.count >= 10000
      end

      grant_on 'comments#vote_up', badge: 'RATED_COMMENT_1', level: 1, to: :user do |comment|
        comment.votes_point >= 25
      end

      grant_on 'comments#vote_up', badge: 'RATED_COMMENT_2', level: 2, to: :user do |comment|
        comment.votes_point >= 50
      end

      grant_on 'comments#vote_up', badge: 'RATED_COMMENT_3', level: 3, to: :user do |comment|
        comment.votes_point >= 75
      end

      grant_on 'comments#vote_up', badge: 'RATED_COMMENT_4', level: 4, to: :user do |comment|
        comment.votes_point >= 100
      end

      grant_on 'comments#vote_up', badge: 'RATED_COMMENT_5', level: 5, to: :user do |comment|
        comment.votes_point >= 200
      end

      grant_on 'articles#vote_up', badge: 'WRITER_1', level: 1, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_point >= 1 }.count >= 5
      end

      grant_on 'articles#vote_up', badge: 'WRITER_2', level: 2, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_point >= 1 }.count >= 25
      end

      grant_on 'articles#vote_up', badge: 'WRITER_3', level: 3, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_point >= 1 }.count >= 75
      end

      grant_on 'articles#vote_up', badge: 'WRITER_4', level: 4, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_point >= 1 }.count >= 150
      end

      grant_on 'articles#vote_up', badge: 'WRITER_5', level: 5, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_point >= 1 }.count >= 250
      end

      grant_on 'articles#vote_up', badge: 'RATED_ARTICLE_1', level: 1, to: :author do |article|
        article.votes_point >= 25
      end

      grant_on 'articles#vote_up', badge: 'RATED_ARTICLE_2', level: 2, to: :author do |article|
        article.votes_point >= 75
      end

      grant_on 'articles#vote_up', badge: 'RATED_ARTICLE_3', level: 3, to: :author do |article|
        article.votes_point >= 150
      end

      grant_on 'articles#vote_up', badge: 'RATED_ARTICLE_4', level: 4, to: :author do |article|
        article.votes_point >= 300
      end

      grant_on 'articles#vote_up', badge: 'RATED_ARTICLE_5', level: 5, to: :author do |article|
        article.votes_point >= 500
      end

      grant_on 'comments#create', badge: 'HOLIVAR_1', level: 1, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 25
      end

      grant_on 'comments#create', badge: 'HOLIVAR_2', level: 2, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 100
      end

      grant_on 'comments#create', badge: 'HOLIVAR_3', level: 3, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 500
      end

      grant_on 'articles#show', badge: 'ARTICLE_VIEWS_1', level: 1, to: :author do |article|
        article.impressions_count >= 100
      end

      grant_on 'articles#show', badge: 'ARTICLE_VIEWS_2', level: 2, to: :author do |article|
        article.impressions_count >= 1000
      end

      grant_on 'articles#show', badge: 'ARTICLE_VIEWS_3', level: 3, to: :author do |article|
        article.impressions_count >= 10000
      end

      grant_on 'profiles#subscribe', model_name: 'User', badge: 'badges.subscribable.1.title', level: 1, to: :itself do |user|
        user.subscribers.count >= 10
      end

      grant_on 'profiles#subscribe', model_name: 'User', badge: 'badges.subscribable.2.title', level: 2, to: :itself do |user|
        user.subscribers.count >= 100
      end

      grant_on 'profiles#subscribe', model_name: 'User', badge: 'badges.subscribable.3.title', level: 3, to: :itself do |user|
        user.subscribers.count >= 1000
      end

    end
  end
end