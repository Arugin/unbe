class GalleriesController < ApplicationController
  def index
    @galleries = Gallery.all.page(params[:page])
    respond_with @galleries
  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy
  end
end
