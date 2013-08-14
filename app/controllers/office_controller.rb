class OfficeController < ApplicationController

  before_filter :authenticate_user!

  def index
  end

  def articles
    @articles = Article.search_for(current_user, params)
  end

  def cycles
    @cycles = Cycle.search_for(current_user, params)
  end
end
