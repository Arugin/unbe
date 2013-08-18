class ProfilesController < ApplicationController
  def user_cycles
    @user = User.find(params[:id])
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
  end

  def user_article
    @article = Article.find(params[:id])
    @user = @article.author
  end

  def show_settings

  end

  def update_settings

  end

end
