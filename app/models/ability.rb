class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new # guest user (not logged in)

    can :read, Article
    can :read, Cycle
    can :read, User
    can :draft, Article do |article|
      article.is_garbage || article.tmpContent.present?
    end
    cannot :index, User


    if user.has_role? :USER or user.has_role? :MODERATOR

      can :manage, Article, :author => user
      cannot :destroy, Article
      can :destroy, Article, :author => user, :isApproved => false, :isUpdated => false

      can :manage, Cycle, :author => user
      cannot :destroy, Cycle
      can :destroy, Cycle do |cycle|
        (cycle.author == user)&&(cycle.articles.empty?)&&(not(cycle.system))
      end

      can :manage, Gallery, :author => user
      can :manage, Content::BaseContent, :author => user

      can :update, User, :_id => user._id
      can :create, Comment
      can :vote_up, [Comment,Article, Content::BaseContent]
      can :vote_down, [Comment,Article, Content::BaseContent]
      can :destroy, Comment do |comment|
        (comment.user == user)&&(comment.votes_point == 0)
      end

      #cannot :read, Article
      cannot :show, Article do |article|
         article.is_garbage
      end
      cannot :approve, Article
      cannot :to_news, Article
      cannot :to_garbage, Article
      cannot :approve, Content::BaseContent
      cannot :publish_news, Article
      cannot :publish_and_approve, Article
      cannot :automatic_approve, Article
      cannot :system_tag, Article
      cannot :vote_up, [Article, Content::BaseContent], :author => user
      cannot :vote_down, [Article, Content::BaseContent], :author => user
      cannot :vote_up, Comment, :user => user
      cannot :vote_down, Comment, :user => user

    end

    if user.has_role? :MODERATOR

      can :approve, Article
      can :to_news, Article
      can :approve, Content::BaseContent
      can :automatic_approve, Article

    end

    if user.has_role? :ADMIN

      can :manage, :all

      cannot :destroy, Article
      can :destroy, Article, :isApproved => false, :isUpdated => false
      can :destroy, Article, :is_garbage => true

      cannot :destroy, Cycle
      can :destroy, Cycle do |cycle|
        (cycle.articles.empty?)&&(cycle.system == false)
      end

      cannot :vote_up, [Article, Content::BaseContent], :author => user
      cannot :vote_down, [Article, Content::BaseContent], :author => user
      cannot :vote_up, Comment, :user => user
      cannot :vote_down, Comment, :user => user

    end
  end
end
