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

      grant_on 'users#update', badge: 'badges.communicable.title', temporary: true do |user|
        user.full_profile?
      end

      grant_on ['articles#create'], badge: 'badges.part_of_whole.title', to: :author do |subject|
        subject.author.full_actions?
      end

      grant_on ['contents#create'], model_name: 'Content', badge: 'badges.part_of_whole.title', to: :author do |subject|
        subject.author.full_actions?
      end

      grant_on 'comments#create', badge: 'badges.part_of_whole.title', to: :user do |comment|
        comment.user.full_actions?
      end

      grant_on 'comments#vote_up', badge: 'badges.commentator.1.title', level: 1, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_for.size >= 1 }.count >= 25
      end

      grant_on 'comments#vote_up', badge: 'badges.commentator.2.title', level: 2, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_for.size >= 1 }.count >= 100
      end

      grant_on 'comments#vote_up', badge: 'badges.commentator.3.title', level: 3, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_for.size >= 1 }.count >= 400
      end

      grant_on 'comments#vote_up', badge: 'badges.commentator.4.title', level: 4, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_for.size >= 1 }.count >= 2000
      end

      grant_on 'comments#vote_up', badge: 'badges.commentator.5.title', level: 5, to: :user do |comment|
        comment.user.comments.find_all {|item| item.votes_for.size >= 1 }.count >= 10000
      end

      grant_on 'comments#vote_up', badge: 'badges.rated_comment.1.title', level: 1, to: :user do |comment|
        comment.votes_for.size >= 25
      end

      grant_on 'comments#vote_up', badge: 'badges.rated_comment.2.title', level: 2, to: :user do |comment|
        comment.votes_for.size >= 50
      end

      grant_on 'comments#vote_up', badge: 'badges.rated_comment.3.title', level: 3, to: :user do |comment|
        comment.votes_for.size >= 75
      end

      grant_on 'comments#vote_up', badge: 'badges.rated_comment.4.title', level: 4, to: :user do |comment|
        comment.votes_for.size >= 100
      end

      grant_on 'comments#vote_up', badge: 'badges.rated_comment.5.title', level: 5, to: :user do |comment|
        comment.votes_for.size >= 200
      end

      grant_on 'articles#vote_up', badge: 'badges.writer.1.title', level: 1, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_for.size >= 1 }.count >= 5
      end

      grant_on 'articles#vote_up', badge: 'badges.writer.2.title', level: 2, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_for.size >= 1 }.count >= 25
      end

      grant_on 'articles#vote_up', badge: 'badges.writer.3.title', level: 3, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_for.size >= 1 }.count >= 75
      end

      grant_on 'articles#vote_up', badge: 'badges.writer.4.title', level: 4, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_for.size >= 1 }.count >= 150
      end

      grant_on 'articles#vote_up', badge: 'badges.writer.5.title', level: 5, to: :author do |article|
        article.author.articles.find_all {|item| item.votes_for.size >= 1 }.count >= 250
      end

      grant_on 'articles#vote_up', badge: 'badges.rated_article.1.title', level: 1, to: :author do |article|
        article.votes_for.size >= 25
      end

      grant_on 'articles#vote_up', badge: 'badges.rated_article.2.title', level: 2, to: :author do |article|
        article.votes_for.size >= 75
      end

      grant_on 'articles#vote_up', badge: 'badges.rated_article.3.title', level: 3, to: :author do |article|
        article.votes_for.size >= 150
      end

      grant_on 'articles#vote_up', badge: 'badges.rated_article.4.title', level: 4, to: :author do |article|
        article.votes_for.size >= 300
      end

      grant_on 'articles#vote_up', badge: 'badges.rated_article.5.title', level: 5, to: :author do |article|
        article.votes_for.size >= 500
      end

      grant_on 'comments#create', badge: 'badges.holivar.1.title', level: 1, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 25
      end

      grant_on 'comments#create', badge: 'badges.holivar.2.title', level: 2, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 100
      end

      grant_on 'comments#create', badge: 'badges.holivar.3.title', level: 3, to: :commentable_author do |comment|
        comment.commentable.article? && comment.commentable.comments.count >= 500
      end

      grant_on 'articles#show', badge: 'badges.article_views.1.title', level: 1, to: :author do |article|
        article.impressions_count >= 100
      end

      grant_on 'articles#show', badge: 'badges.article_views.2.title', level: 2, to: :author do |article|
        article.impressions_count >= 1000
      end

      grant_on 'articles#show', badge: 'badges.article_views.3.title', level: 3, to: :author do |article|
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