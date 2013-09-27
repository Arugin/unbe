class ContentsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource class: 'Content::BaseContent', :except => [:show]

  def show
    @content = Content::BaseContent.find(params[:id])
  end

  def index
    @commentable = Gallery.find params[:gallery_id]
  end

  def create
    session[:gallery] ||= request.referer
    @gallery = Gallery.find params[:gallery_id]
    @content = @gallery.contents.build(params[:content_base_content])
    if @content.save
      flash[:notice] = t :CONTENT_ADD_SUCCESSFULLY
      redirect_to session.delete(:gallery)
    else
      render 'new'
    end
  end

  def destroy
    session[:destroy_gallery] ||= request.referer
    @content = Content::BaseContent.find(params[:id])

    message = t :UNABLE_TO_DELETE_CONTENT
    begin
      if @content.destroy == false
        redirect_to session.delete(:destroy_gallery), alert: message + @content.errors.full_messages.join(', ')
        return
      end
    rescue Exception => e
      redirect_to ession.delete(:destroy_gallery), alert: message + e.message
      return
    end
    redirect_to session[:destroy_gallery], notice: t(:CONTENT_REMOVE_SUCCESS)
  end

end