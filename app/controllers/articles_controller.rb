class ArticlesController < ApplicationController
  def index
    @articles = Article.page(params[:page]).per(12)
  end
end
