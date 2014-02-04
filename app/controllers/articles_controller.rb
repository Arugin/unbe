#encoding: utf-8
class ArticlesController < ApplicationController

  before_filter :authenticate_user!, :except => [:news,:index, :show, :by_area]
  load_and_authorize_resource :except => [:news, :index, :by_area]

  respond_to :html, :js

  def index
    @articles = Article.approved(current_user, params).page(params[:page]).per(9)
    @article_areas = ArticleArea.without_news
    respond_with @articles
  end

  def show
    @article = Article.find(params[:id])
    impressionist(@article, '', unique: [:session_hash, :ip_address])
    @comments = @article.comments.page(params[:page]).per(15)
    respond_with @comments
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user

    if @article.save
      publish_and_approve @article
      change_system_tag
      push_to_news
      add_script
      @article.save
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
      change_system_tag
      push_to_news
      add_script
      @article.save
      redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])

    message = t :UNABLE_TO_DELETE_ARTICLE
    begin
      unless @article.destroy
        redirect_to @article, alert: message + @article.errors.full_messages.join(', ')
        return
      end
    rescue Exception => e
      redirect_to @article, alert: message + e.message
      return
    end
    redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_REMOVE_SUCCESS)
  end

  def news
    @articles = Article.last_news(current_user, params).page(params[:page]).per(12)
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
    if can? :automatic_approve, @article
      @article.approve
    end
    redirect_to office_articles_path(scope:'current_user'), notice: t(:ARTICLE_PUBLISH_SUCCESS)
  end

  def approve
    @article = Article.find(params[:id])
    if params['additional'] == 'to_news' && can?(:to_news, @article)
      # TODO: move to model
      @article.to_news = true
    end
    @article.approve
    redirect_to non_approved_articles_path, notice: t(:ARTICLE_APPROVE_SUCCESS)
  end

  def by_area
    @article_areas = ArticleArea.without_news
    @article_area =  ArticleArea.where(title: params[:article_area]).first
    @articles = Article.by_area(current_user, params, @article_area).page(params[:page]).per(9)
    @address_additor = ''
    unless @article_area.nil?
      @address_additor = "?article_area=#{@article_area.id}"
    end
    render :index
  end

  def new_news
    @article = Article.new
  end

  def vote_up
    session[:article_votable] ||= request.referer
    @article = Article.find(params[:id])
    current_user.vote(@article, :up)
    redirect_to session.delete(:article_votable)
  end

  def vote_down
    session[:article_votable] ||= request.referer
    @article =  Article.find(params[:id])
    current_user.vote(@article, :down)
    redirect_to session.delete(:article_votable)
  end

  def to_garbage
    @article = Article.find(params[:id])
    @article.to_garbage
    redirect_to non_approved_articles_path, notice: t(:ARTICLE_APPROVE_TO_GARBAGE)
  end

  def garbage
    @articles = Article.where(is_garbage:true).page(params[:page])
    @article_areas = ArticleArea.without_news
  end

  protected

  def publish_and_approve(article)
    if can? :publish_and_approve, article
      article.publish
      article.approve
    end
  end

  def change_system_tag
    if can? :system_tag, @article
      @article.system_tag = params[:article][:system_tag]
    end
  end

  def push_to_news
    if can? :to_news, @article
      @article.to_news = params[:article][:to_news]
    end
  end

  def add_script
    if can? :script, @article
      @article.script = params[:article][:script]
    end
  end

end
