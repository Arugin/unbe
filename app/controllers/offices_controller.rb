class OfficesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :scope, except: [:non_approved_articles,:non_approved_contents]
  include Concerns::BulkOperationable

  bulk_actions :delete, :tag

  respond_to :html, :js, :json

  # TODO: Move it to model
  def show
    @last_pages = []

    elements = Impression.where(user_id: current_user._id).order_by([:created_at, :desc])
    elements.each do |element|
      break if @last_pages.size >= 10
      checking = element.impressionable_type.constantize.find(element.impressionable_id) rescue @last_pages.last
      unless checking == @last_pages.last
        @last_pages << checking
      end
    end

    @my_activities = PublicActivity::Activity.where(owner_id: current_user.id).order_by(created_at: :desc).page(params[:page]).per(20)
    @comments = PublicActivity::Activity.where(:recipient_id.in => current_user.all_resources_ids).order_by(created_at: :desc).page(params[:page]).per(20)
  end

  def articles
    params[:sort_by] ||= 'created_at'
    params[:direction] ||= 'desc'
    if params[:unprocessed]
      scope = Article.unprocessed(current_user, params)
    else
      scope = Article.unscoped.search_for(current_user, params)
    end
    @articles = scope.order_by(params[:sort_by].to_sym => params[:direction].to_sym).page(params[:page]).per(15)

    respond_with @articles
  end

  def cycles
    params[:sort_by] ||= 'created_at'
    params[:direction] ||= 'desc'

    @cycles = Cycle.unscoped.search_for(current_user, params).order_by(params[:sort_by].to_sym => params[:direction].to_sym).page(params[:page]).per(15)

    respond_with @cycles
  end

  def non_approved_articles
    @articles = Article.non_approved(current_user, params).page(params[:page]).per(15)
    authorize! :approve, Article
    respond_with @articles
  end

  def galleries
    @galleries = Gallery.search_for(current_user,params).page(params[:page]).per(10)
    respond_with @galleries
  end

  def non_approved_contents
    @contents = Content::BaseContent.non_approved(current_user, params).page(params[:page])
    authorize! :approve, Content::BaseContent
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

  private

  def scope
    if params[:scope].nil?
      params[:scope] = 'current_user'
    end
  end
end
