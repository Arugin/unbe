class GalleriesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:index, :show]

  respond_to :html, :js

  def index
    @galleries = Gallery.all.page(params[:page])
    respond_with @galleries
  end

  def show
    @gallery = Gallery.find(params[:id])
    @comments = @gallery.comments.page(params[:page]).per(15)
    @contents = @gallery.contents.page(params[:page]).per(5)
    respond_with @comments
  end

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.author = current_user

    if @gallery.save
      redirect_to office_galleries_path(scope:'current_user'), notice: t(:GALLERY_CREATE_SUCCESS)
    else
      render action: "new"
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    @contents = @gallery.contents.page(params[:page]).per(5)
    respond_with @contents
  end

  def update
    @gallery = Gallery.find(params[:id])

    if @gallery.update_attributes(params[:gallery])
      redirect_to office_galleries_path(scope:'current_user'), notice: t(:GALLERY_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])

    message = t :UNABLE_TO_DELETE_GALLERY
    begin
      if @gallery.destroy == false
        redirect_to @gallery, alert: message + @gallery.errors.full_messages.join(', ')
        return
      end
    rescue Exception => e
      redirect_to @gallery, alert: message + e.message
      return
    end
    redirect_to office_galleries_path(scope:'current_user'), notice: t(:GALLERY_REMOVE_SUCCESS)
  end
end
