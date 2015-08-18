class ContentsController < ApplicationController

  include Concerns::Votable

  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource except: [:show, :index], param_method: :content_base_content_params


  respond_to :html, :js

  def show
    @content = Content.find(params[:id])
    @comments = @content.comments.page(params[:page]).per(25)
    impressionist(@content,'', unique: [:session_hash, :ip_address])
    respond_with @comments
  end

  def approve
    off_public_activity(Content) do
      @content = Content.find(params[:id])
      @content.author.add_points(10) unless @content.approved_to_news
      @content.approved_to_news = params[:approved]
      @content.reviewed = true
      @content.save
    end
    redirect_to non_approved_contents_office_path, notice: t(:CONTENT_APPROVE_SUCCESS)
  end

  def index
    params[:sort_by] ||= 'created_at'
    params[:direction] ||= 'desc'

    @contents = Content.approved(current_user, params).page(params[:page]).per(12)

    respond_with @contents
  end

  def create
    session[:gallery] ||= request.referer
    @gallery = Gallery.find params[:gallery_id]
    @content = @gallery.contents.build(contents_params)
    @content.author = current_user
    if @content.save
      flash[:notice] = t :CONTENT_ADD_SUCCESSFULLY
      redirect_to session.delete(:gallery)
    else
      render 'new'
    end
  end

  def edit
    @content = Content.find(params[:id])
  end

  def update
    @content = Content.find(params[:id])

    if @content.author.nil?
      @content.author = current_user
      @content.save
    end
    if @content.update_attributes(contents_params)
      @content.reviewed = false
      @content.save
      redirect_to edit_gallery_path(@content.contentable), notice: t(:CONTENT_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
    session[:destroy_gallery] ||= request.referer
    @content = Content.find(params[:id])

    message = t :UNABLE_TO_DELETE_CONTENT
    begin
      unless @content.destroy
        redirect_to session.delete(:destroy_gallery), alert: message + @content.errors.full_messages.join(', ')
        return
      end
    rescue => e
      redirect_to session.delete(:destroy_gallery), alert: message + e.message
      return
    end
    redirect_to session[:destroy_gallery], notice: t(:CONTENT_REMOVE_SUCCESS)
  end

  private

  def contents_params
    params.require(:contents).permit(:title, :description, :src, :tag_list, :contentable_id)
  end

end