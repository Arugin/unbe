class UsersController < ApplicationController

  before_filter :authenticate_user!

  def index
    @users = User.all.asc(:username)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.is_active = true

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => "User information updated successfully"
    else
      redirect_to edit_user_path(@user), :alert => "Unable to update user information"
    end
  end

  def destroy
  end

  def edit
    @user = User.find(params[:id])
  end
end
