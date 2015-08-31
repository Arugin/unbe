class OfficesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :scope, except: [:non_approved_articles,:non_approved_contents]
  include Concerns::BulkOperationable

  bulk_actions :delete, :tag

  respond_to :html, :js, :json

  # TODO: Move it to model
  def show
    @last_pages = []

    elements = Impression.where(user_id: current_user.id).order(created_at: :desc)
    elements.each do |element|
      break if @last_pages.size >= 10
      checking = element.impressionable_type.constantize.find(element.impressionable_id) rescue @last_pages.last
      unless checking == @last_pages.last
        @last_pages << checking
      end
    end

    @my_activities = PublicActivity::Activity.where(owner_id: current_user.id).order(created_at: :desc).page(params[:page]).per(20)
    comments = PublicActivity::Activity.where(trackable_type: 'Comment').includes(trackable: :commentable).order(created_at: :desc).select do|activity|
      resource = activity.trackable
      resource.commentable.author == current_user if resource.present? && resource.commentable.present?
    end
    @comments = Kaminari.paginate_array(comments).page(params[:page]).per(20)
  end

  def articles
    if params[:unprocessed]
      scope = Article.unprocessed(current_user)
    else
      scope = Article.where(author: current_user)
    end
    @articles = Article.search_for(params, scope).page(params[:page]).per(15)

    respond_with @articles
  end

  def cycles
    @cycles = Cycle.search_for(params, Cycle.where(author: current_user)).page(params[:page]).per(15)

    respond_with @cycles
  end

  def usage
    authorize! :usage, SystemManagement
    @system_info = SystemManagement.get_system_info
    @storage_info = SystemManagement.get_storage_info
  end

  def non_approved_articles
    authorize! :approve, Article
    scope = Article.non_approved
    @articles = Article.search_for(params, scope).page(params[:page]).per(25)
    respond_with @articles
  end

  def galleries
    @galleries = Gallery.search_for(params, Gallery.where(author: current_user)).page(params[:page]).per(10)
    respond_with @galleries
  end

  def non_approved_contents
    authorize! :approve, Content

    scope = Content.non_approved
    @contents = Content.search_for(params, scope).page(params[:page]).per(25)

    respond_with @contents
  end

  def assign_badges_show
    authorize! :assign_badges, User
    @users = User.random
    @badges = Merit::Badge.all
  end

  def assign_badges_update
    authorize! :assign_badges, User
    @user = User.find params[:user][:id]
    @user.add_badge params[:user][:badge_id]
    redirect_to assign_badges_office_path, notice: t(:BADGE_ADDED, badge: params[:user][:badge_id], user: @user.name)
  end

  def add_points_show
    authorize! :add_points, User
    @users = User.random
  end

  def add_points_update
    authorize! :add_points, User
    @user = User.find params[:user][:id]
    @user.add_points params[:user][:points].to_i
    redirect_to add_points_office_path, notice: t(:POINTS_ADDED, points: params[:user][:points], user: @user.name)
  end

  def subscriptions
    @subscriptions = current_user.subscriptions.page(params[:page])
    @subscribers = current_user.subscribers.page(params[:page])
  end

  def settings
    @user = current_user
  end

  private

  def scope
    if params[:scope].nil?
      params[:scope] = 'current_user'
    end
  end
end
