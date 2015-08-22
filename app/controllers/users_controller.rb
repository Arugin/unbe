class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:email, :omni_save]
  load_and_authorize_resource except: [:email, :omni_save]

  respond_to :html, :js

  def index
    @users = User.page(params[:page]).per(15)
    respond_with @users
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.is_active = true

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
      Cycle.create ({:title => 'NO_CYCLE', :description =>"NO_CYCLE_DESC",:author => @user})
    else
      render action: "new"
    end
  end

  def update
    begin
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to profile_path, :notice => t('USER_INFO_UPDATE_SUCCESS')
      else
        redirect_to edit_profile_path(@user), :alert => t('USER_INFO_CAN_NOT_BE_UPDATED')
      end
    rescue => e
      redirect_to edit_profile_path(@user), :alert => "#{t('USER_INFO_CAN_NOT_BE_UPDATED')}: #{e.message}"
    end
  end

  def destroy
    @user = User.find(params[:id])

    message = t :UNABLE_TO_DELETE_USER
    begin
      unless @user.destroy
        redirect_to users_path, alert: message + @user.errors.full_messages.join(', ')
        return
      end
    rescue => e
      redirect_to users_path, alert: message + e.message
      return
    end
    redirect_to users_path, notice: t(:USER_REMOVE_SUCCESS)
  end

  def edit
    @user = User.find(params[:id])
  end

  def change_role
    authorize! :change_role, User
    @user = User.find(params[:id])
    @user.change_role(params[:role])
    redirect_to users_path, :notice => t(:USER_ROLE_CHANGED)
  end

  def block
    @user = User.find(params[:id])
    @user.access
    redirect_to users_path, :notice => t(:USER_ACCESS_CHANGED)
  end

  def email
    if session[:omniauth]
      @user = User.new
      @user.email = params[:email]
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.apply_omniauth(session[:omniauth], false)
    else
      redirect_to new_user_registration_url
    end
  end

  def omni_save
    if session[:omniauth]
      @user = User.new user_params
      @user.password = user_params[:password]
      @user.password_confirmation = user_params[:password_confirmation]
      @user.apply_omniauth(session[:omniauth], session[:omniauth]['info']['email'])
      if @user.save
        @user.authentications.create!(provider: session[:omniauth]['provider'], uid: session[:omniauth]['uid'])
        session[:omniauth] = nil
        # Create a new User through omniauth
        # Register the new user + create new authentication
        flash[:notice] = t('devise.registrations.signed_up')
        sign_in_and_redirect(:user, @user)
      else
        render 'email'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :second_name, :gender_id, :from, :about, :email, :password, :password_confirmation, :remember_me, :subscribed, avatar_attributes:[:id, :file], settings_attributes:[:id, :unlock_top_menu])
  end

end