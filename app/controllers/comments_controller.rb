class CommentsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index]
  load_and_authorize_resource :except => [:index ]

  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def create
    session[:commentable] ||= request.referer
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = t :COMMENT_ADD_SUCCESSFULLY
      redirect_to session.delete(:commentable)
    else
      render 'new'
    end
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
    puts 'iiiiiiiiiiiiiiiiiiiii',name
    if name == 'content_base_content'
      'Content::BaseContent'
    else
      name.classify
    end
  end
end