class OfficeController < ApplicationController

  before_filter :authenticate_user!
  before_filter :scope, except: [:non_approved,:non_approved_content]

  respond_to :html, :js

  def index
  end

  def articles
    @articles = Article.search_for(current_user,params).order_by([:created_at, :desc]).page(params[:page]).per(7)
    respond_with @articles
  end

  def cycles
    @cycles = Cycle.search_for(current_user, params).page(params[:page])
    respond_with @cycles
  end

  def non_approved
    @articles = Article.non_approved(current_user, params).page(params[:page])
    authorize! :approve, Article
    respond_with @articles
  end

  def galleries
    @galleries = Gallery.search_for(current_user,params).order_by([:created_at, :desc]).page(params[:page]).per(7)
    respond_with @galleries
  end

  def non_approved_content
    @contents = Content::BaseContent.non_approved(current_user, params).page(params[:page])
    authorize! :approve, Content::BaseContent
    respond_with @contents
  end

  private

  def scope
    if params[:scope].nil?
      params[:scope] = 'current_user'
    end
  end
end
