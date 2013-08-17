class OfficeController < ApplicationController

  before_filter :authenticate_user!

  def index
  end

  def articles
    @articles = Article.search_for(current_user, {scope: 'current_user'}).order_by([:created_at, :desc])
  end

  def cycles
    @cycles = Cycle.search_for(current_user, {scope: 'current_user'})
  end

  def non_approved
    @articles = Article.non_approved
    authorize! :approve, Article
  end
end
