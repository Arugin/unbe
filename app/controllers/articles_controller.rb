#encoding: utf-8
class ArticlesController < ApplicationController

  include Concerns::BulkOperationable
  include Concerns::Votable

  before_filter :authenticate_user!, except: [:news,:index, :show]
  load_and_authorize_resource except: [:news, :index]

  bulk_actions :delete, :tag

  respond_to :html, :js, :json

  def index
    params[:sort_by] ||= 'created_at'
    params[:direction] ||= 'desc'

    @article_area =  ArticleArea.where(title: params[:article_area]).first
    @address_additor = ''
    unless @article_area.nil?
      @address_additor = "?article_area=#{@article_area.id}"
    end

    @articles = Article.unscoped.by_area(current_user, params, @article_area).order_by(params[:sort_by].to_sym => params[:direction].to_sym).page(params[:page]).per(9)

    @article_areas = ArticleArea.all

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
    @article.author = current_user
    @article
  end

  def create
    @article = Article.new(params[:article])
    @article.author = current_user

    if @article.save
      additional_actions
      redirect_to articles_office_path(scope:'current_user'), notice: t(correct_message(:create))
    else
      render action: "new"
    end
  end

  def update
    @article = Article.find(params[:id])

    @old_article = @article.dup

    if @article.update_attributes(params[:article])
      @article.to_changed
      additional_actions
      redirect_to articles_office_path(scope:'current_user'), notice: t(correct_message(:update))
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
    redirect_to articles_office_path(scope:'current_user'), notice: t(:ARTICLE_REMOVE_SUCCESS)
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
    return redirect_to articles_office_path(scope:'current_user'), alert: t(:CANNOT_PUBLISH_ARTICLE_TMP_CONTENT_BLANK) if @article.tmpContent.blank?
    @article.publish
    redirect_to articles_office_path(scope:'current_user'), notice: t(:ARTICLE_PUBLISH_SUCCESS)
  end

  def approve
    @article = Article.find(params[:id])
    if params['additional'] == 'to_news' && can?(:to_news, @article)
      # TODO: move to model
      @article.to_news = true
    end
    @article.approve
    redirect_to non_approved_articles_office_path, notice: t(:ARTICLE_APPROVE_SUCCESS)
  end

  def new_news
    @article = Article.new
  end


  def to_garbage
    @article = Article.find(params[:id])
    @article.to_garbage
    redirect_to non_approved_articles_office_path, notice: t(:ARTICLE_APPROVE_TO_GARBAGE)
  end

  def garbage
    @articles = Article.where(state: 'Article::Garbage').page(params[:page])
    @article_areas = ArticleArea.all
  end

  protected

  def correct_message(action)
    config = (params[:article][:publish].to_i == 1) ? :publish : :no
    config = (params[:article][:approve].to_i == 1) ? :approve : config

    messages = {
      create: {
        no: :ARTICLE_CREATE_SUCCESS,
        publish: :ARTICLE_CREATE_PUBLISH_SUCCESS,
        approve: :ARTICLE_CREATE_APPROVE_SUCCESS
      },
      update: {
        no: :ARTICLE_UPDATE_SUCCESS,
        publish: :ARTICLE_UPDATE_PUBLISH_SUCCESS,
        approve: :ARTICLE_UPDATE_APPROVE_SUCCESS
      }
    }

    messages[action][config]

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

  def automatic_publish
    if params[:article][:publish].to_i == 1
      @article.publish
    end
  end

  def automatic_approve
    if params[:article][:approve].to_i == 1 && can?(:approve, @article)
      @article.approve
    end
  end

  def additional_actions
    change_system_tag
    push_to_news
    automatic_publish
    automatic_approve
    add_script
    @article.save
  end

end
