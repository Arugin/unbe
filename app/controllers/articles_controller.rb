#encoding: utf-8
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, :except => [:news,:index, :show]
  load_and_authorize_resource :except => [:news, :index, :show, :by_area]

  respond_to :html, :js

  def index
    @articles = Article.search_for(current_user, params).page(params[:page])
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
    @articles = Article.last_news.page params[:page]
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
    redirect_to office_articles_path, notice: t(:ARTICLE_PUBLISH_SUCCESS)
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
    @articles = Article.where(article_area: @article_area).order_by([:created_at, :desc]).and({:isApproved => true}).page(params[:page])
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
