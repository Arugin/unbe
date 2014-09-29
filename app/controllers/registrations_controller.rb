class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    if verify_recaptcha
      super
    else
      build_resource
      clean_up_passwords(resource)
      flash.now[:alert] = t(:CAPTCHA_ERROR)
      flash.delete :recaptcha_error
      render :new
    end
  end

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :heard_how,
               :email, :password, :password_confirmation, :subscribed)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name,
               :email, :password, :password_confirmation, :current_password, :subscribed)
    end
  end

end