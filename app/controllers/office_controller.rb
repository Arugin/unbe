class OfficeController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html, :js

  def index
  end

  def articles
    @articles = Article.search_for(current_user,params).order_by([:created_at, :desc]).page(params[:page])
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
end
