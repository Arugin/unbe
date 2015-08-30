class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    can :read, Article
    can :read, Cycle
    can :read, User
    can :subscribe, User do |target|
      target != user
    end

    can :draft, Article do |article|
      article.garbage? || article.tmp_content.present?
    end
    cannot :index, User


    if user.has_role? :USER or user.has_role? :MODERATOR

      can :manage, Article, :author => user
      cannot :destroy, Article
      can :destroy, Article, :author => user, :approved? => false, :is_updated? => false

      can :manage, Cycle, :author => user
      cannot :destroy, Cycle
      can :destroy, Cycle do |cycle|
        (cycle.author == user)&&(cycle.articles.empty?)&&(not(cycle.system))
      end

      can :manage, Gallery, :author => user
      can :manage, Content, :author => user

      can :update, User, :id => user.id

      can :create, Comment
      can :vote_up, [Comment,Article, Content] do |item|
        user.points >= Utils.RANKS[1]
      end
      can :vote_down, [Comment,Article, Content]do |item|
        user.points >= Utils.RANKS[2]
      end
      can :destroy, Comment do |comment|
        (comment.user == user)&&(comment.votes_for.size == 0)
      end
      can :update, Comment do |comment|
        (comment.user == user)&&(Time.now < 1.days.since(comment.created_at))
      end


      cannot :show, Article do |article|
        article.garbage?
      end
      cannot :approve, Article
      cannot :script, Article
      cannot :to_news, Article
      cannot :to_garbage, Article
      cannot :approve, Content
      cannot :publish_news, Article
      cannot :system_tag, Article
      cannot :vote_up, [Article, Content, Cycle], author: user
      cannot :vote_down, [Article, Content, Cycle], author: user
      cannot :vote_up, Comment, user: user
      cannot :vote_down, Comment, user: user

    end

    if user.has_role? :MODERATOR

      can :approve, Article
      can :to_news, Article
      can :approve, Content

    end

    if user.has_role? :ADMIN

      can :manage, :all

      cannot :destroy, Article
      can :destroy, Article, :approved? => false, :is_updated? => false
      can :destroy, Article, :garbage? => true

      cannot :destroy, Cycle
      can :destroy, Cycle do |cycle|
        (cycle.articles.empty?)&&(cycle.system == false)
      end

      cannot :vote_up, [Article, Content], :author => user
      cannot :vote_down, [Article, Content], :author => user
      cannot :vote_up, Comment, user: user
      cannot :vote_down, Comment, user: user
      cannot :subscribe, User do |target|
        target == user
      end

    end
  end
end
