class CommentsController < ApplicationController

  include Concerns::Votable

  before_filter :authenticate_user!, :except => [:index]
  load_and_authorize_resource :except => [:index ]

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = t :COMMENT_ADD_SUCCESSFULLY
      redirect_to @commentable
    else
      render 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update_attributes(params[:comment])
      redirect_to @comment.commentable, notice: t(:COMMENT_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
    session[:remove_comment] ||= request.referer
    @comment = Comment.find(params[:id])

    message = t :UNABLE_TO_DELETE_COMMENT
    begin
      unless @comment.destroy
        redirect_to @comment, alert: message + @comment.errors.full_messages.join(', ')
        return
      end
    rescue Exception => e
      redirect_to @comment, alert: message + e.message
      return
    end
    redirect_to session.delete(:remove_comment), notice: t(:COMMENT_REMOVE_SUCCESS)
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return specific_name($1).constantize.find(value)
      end
    end
    nil
  end

  def specific_name(name)
    if name == 'content_base_content'
      'Content::BaseContent'
    else
      name.classify
    end
  end

end