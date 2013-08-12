class OfficeController < ApplicationController
  def index
  end

  def articles
    @articles = Article.search_for(current_user, params)
  end
end
