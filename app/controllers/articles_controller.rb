class ArticlesController < ApplicationController
  def index
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
  end

  def update
  end

  def destroy
  end

  def news
    @articles = Article.last_news
  end

  def edit
  end
end
