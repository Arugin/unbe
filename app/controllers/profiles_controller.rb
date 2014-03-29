class ProfilesController < ApplicationController

  respond_to :html, :js

  def cycles
    @user = User.find(params[:id])
    @cycles = @user.cycles.page(params[:page])
    respond_with @cycles
  end

  def show
    @user = User.find(params[:id])
  end

  def projects
    @user = User.find(params[:id])
  end

  def articles
    @cycle = Cycle.find(params[:id])
    @user = @cycle.author
    @articles = @cycle.articles.where(state: 'Article::Approved').order_by([:created_at, :desc]).page(params[:page]).per(5)
    respond_with @articles
  end

  def article
    @article = Article.find(params[:id])
    @user = @article.author
  end

  def edit
    @user = current_user
    if @user.avatar.nil?
      @user.avatar = Picture.new
    end
  end

  def galleries
    @user = User.find(params[:id])
    @galleries = @user.galleries.page(params[:page]).per(1)
    respond_with @galleries
  end

  def comments
    @user = User.find(params[:id])
    @comments = @user.comments.order_by([:created_at, :desc]).page(params[:page]).per(20)
    respond_with @comments
  end

end
