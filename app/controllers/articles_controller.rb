#encoding: utf-8
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, :except => [:news,:index]

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

    if @article.save
      redirect_to office_articles_path, notice: t(:ARTICLE_CREATE_SUCCESS)
    else
      render action: "new"
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      redirect_to @article, notice: t(:ARTICLE_UPDATE_SUCCESS)
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
  end

  def publish
    @article = Article.find(params[:id])
    @article.isPublished = true
    @article.save
    redirect_to office_articles_path, notice: t(:ARTICLE_PUBLISH_SUCCESS)
  end

end
