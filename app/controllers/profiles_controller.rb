class ProfilesController < ApplicationController

  respond_to :html, :js

  def user_cycles
    @user = User.find(params[:id])
    @cycles = @user.cycles.page(params[:page])
    respond_with @cycles
  end

  def user_profile
    @user = User.find(params[:id])
  end

  def user_projects
    @user = User.find(params[:id])
  end

  def user_articles
    @cycle = Cycle.find(params[:id])
    @user = @cycle.author
    @articles = @cycle.articles.not_in(is_garbage: true).where({isApproved: true}).order_by([:created_at, :desc]).page(params[:page]).per(5)
    respond_with @articles
  end

  def user_article
    @article = Article.find(params[:id])
    @user = @article.author
  end

  def edit
    @user = current_user
    if @user.avatar.nil?
      @user.avatar = Picture.new
    end
  end

  def user_galleries
    @user = User.find(params[:id])
    @galleries = @user.galleries.page(params[:page]).per(1)
    respond_with @galleries
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments.page(params[:page]).per(20)
    respond_with @comments
  end

end
