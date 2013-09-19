class CommentsController < ApplicationController

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
      redirect_to session.delete(:commentable)
    else
      render :action => 'new'
    end


  end

  def find_commentable
    puts params
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end