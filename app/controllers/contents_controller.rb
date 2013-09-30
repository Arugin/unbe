class ContentsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource class: 'Content::BaseContent', :except => [:show]

  respond_to :html, :js

  def show
    @content = Content::BaseContent.find(params[:id])
    @comments = @content.comments.order_by([:created_at, :asc]).page(params[:page]).per(15)
    respond_with @comments
  end

  def approve
    @content = Content::BaseContent.find(params[:id])
    @content.approved_to_news = params[:approved]
    @content.reviewed = true
    @content.save
    redirect_to non_approved_contents_path, notice: t(:CONTENT_APPROVE_SUCCESS)
  end

  def index
    @commentable = Gallery.find params[:gallery_id]
  end

  def create
    session[:gallery] ||= request.referer
    @gallery = Gallery.find params[:gallery_id]
    @content = @gallery.contents.build(params[:content_base_content])
    @content.author = current_user
    if @content.save
      flash[:notice] = t :CONTENT_ADD_SUCCESSFULLY
      redirect_to session.delete(:gallery)
    else
      render 'new'
    end
  end

  def edit
    @content = Content::BaseContent.find(params[:id])
  end

  def update
    @content = Content::BaseContent.find(params[:id])

    if @content.author.nil?
      @content.author = current_user
      @content.save
    end
    if @content.update_attributes(params[:content_base_content])
      @content.reviewed = false
      @content.save
      redirect_to edit_gallery_path(@content.contentable), notice: t(:CONTENT_UPDATE_SUCCESS)
    else
      render action: "edit"
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

  def vote_up
    session[:content_votable] ||= request.referer
    @content = Content::BaseContent.find(params[:id])
    current_user.vote(@content, :up)
    redirect_to session.delete(:content_votable)
  end

  def vote_down
    session[:content_votable] ||= request.referer
    @content =  Content::BaseContent.find(params[:id])
    current_user.vote(@content, :down)
    redirect_to session.delete(:content_votable)
  end

end