class AuthenticationsController < ApplicationController
  # Load user's authentications (Twitter, Facebook, ....)

  before_filter :authenticate_user!, except: [:create]

  def index
    @authentications = current_user.authentications if current_user
  end

  # Create an authentication when this is called from
  # the authentication provider callback
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(provider: omniauth['provider'], uid: omniauth['uid']).first
    if authentication
      # Just sign in an existing user with omniauth
      # The user have already used this external account
      flash[:notice] = t('devise.sessions.signed_in')
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      # Add authentication to signed in user
      # User is logged in
      current_user.authentications.create!(provider: omniauth['provider'], uid: omniauth['uid'])
      flash[:notice] = t(:PROVIDER_ADDED, provider: omniauth['provider'])
      redirect_to authentications_url
    elsif omniauth['provider'] != 'twitter' && omniauth['provider'] != 'linked_in' && user = new_omniauth_user(omniauth)
      session[:omniauth] = omniauth
      redirect_to(:controller => 'users', :action => 'email')
    elsif user = try_find(omniauth)
      sign_in(:user, user)
      current_user.authentications.create!(provider: omniauth['provider'], uid: omniauth['uid'])
      flash[:notice] = t(:PROVIDER_ADDED, provider: omniauth['provider'])
      redirect_to authentications_url
    elsif (omniauth['provider'] == 'twitter' || omniauth['provider'] == 'vkontakte' || omniauth['provider'] == 'linked_in') &&
        omniauth['uid'] && (omniauth['info']['name'] || omniauth['info']['nickname'] ||
        (omniauth['info']['first_name'] && omniauth['info']['last_name']))
      session[:omniauth] = omniauth.except('extra')
      redirect_to(:controller => 'users', :action => 'email')
    else
      # New user data not valid, try again
      flash[:alert] = t(:SOMETHING_WENT_WRONG)
      redirect_to new_user_registration_url
    end
  end

  # Destroy an authentication
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    provider = @authentication.provider
    @authentication.destroy
    flash[:notice] = t(:successfully_destroyed_authentication, provider: provider)
    redirect_to authentications_url
  end

  protected

  def new_omniauth_user(omniauth)
    user = omniauth_user(omniauth)
    user.valid? ? user : nil
  end

  def try_find(omniauth)
    User.where(email: omniauth_user(omniauth).email).first
  end

  def omniauth_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth, true)
    user
  end

end
