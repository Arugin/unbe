#encoding: utf-8
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, :except => [:news,:index, :show]
  load_and_authorize_resource :except => [:news, :index, :show, :by_area]

  respond_to :html, :js

  def index
    @articles = Article.approved(current_user, params).page(params[:page])
    @article_areas = ArticleArea.without_news
    respond_with @articles
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
      if can? :publish_and_approve, Article
        publish_and_approve @article
      end
      redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_CREATE_SUCCESS)
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
      redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
  end

  def news
    @articles = Article.last_news(current_user, params).page(params[:page]).per(7)
    respond_with @articles
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
    if can? :automatic_approve, Article
      @article.approve
    end
    redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_PUBLISH_SUCCESS)
  end

  def approve
    authorize! :approve, Article
    @article = Article.find(params[:id])
    @article.approve
    redirect_to non_approved_articles_path, notice: t(:ARTICLE_APPROVE_SUCCESS)
  end

  def by_area
    @article_areas = ArticleArea.without_news
    @article_area =  ArticleArea.find(params[:article_area])
    @articles = Article.by_area(current_user, params, @article_area).page(params[:page])
    @address_additor = ''
    unless @article_area.nil?
      @address_additor = "?article_area=#{@article_area.id}"
    end
    render :index
  end

  def new_news
    @article = Article.new
  end

  protected

  def publish_and_approve(article)
    article.publish
    article.approve
  end

end
