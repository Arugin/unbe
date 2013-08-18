#encoding: utf-8
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, :except => [:news,:index, :show]
  load_and_authorize_resource :except => [:news, :index, :show]

  def index
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user

    if @article.save
      redirect_to office_articles_path, notice: t(:ARTICLE_CREATE_SUCCESS)
    else
      render action: "new"
    end
  end

  def update
    @article = Article.find(params[:id])

    @old_article = @article.dup

    if @article.update_attributes(params[:article])

      unless @old_article == @article
        @article.un_publish
      end
      redirect_to office_articles_path, notice: t(:ARTICLE_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
  end

  def news
    @articles = Article.last_news
  end

  def edit
    @article = Article.find(params[:id])
    if @article.tmpContent.nil?
      @article.tmpContent = @article.content
    end
  end

  def publish
    @article = Article.find(params[:id])
    @article.publish
    redirect_to office_articles_path, notice: t(:ARTICLE_PUBLISH_SUCCESS)
  end

  def approve
    authorize! :approve, Article
    @article = Article.find(params[:id])
    @article.approve
    redirect_to non_approved_articles_path, notice: t(:ARTICLE_APPROVE_SUCCESS)
  end

end
