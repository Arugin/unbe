class ProfilesController < ApplicationController

  respond_to :html, :js

  def user_cycles
    @user = User.find(params[:id])
    @cycles = @user.cycles.order_by([:created_at, :desc]).page(params[:page]).per(5)
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
    @articles = @cycle.articles.order_by([:created_at, :desc]).page(params[:page]).per(5)
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

end
