class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  protect_from_forgery
  #enable_authorization

  before_filter :set_locale
  after_filter :set_access_control_headers

  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  # https://gist.github.com/gonzedge/1563416
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, Mongoid::Errors::DocumentNotFound, with: lambda { |exception| render_error 404, exception }
  end

# Get locale from top-level domain or return nil if such locale is not available
# You have to put something like:
#   127.0.0.1 application.com
#   127.0.0.1 application.it
#   127.0.0.1 application.pl
# in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
  end

  rescue_from CanCan::Unauthorized do |exception|
    access_denied(exception)
  end

  #we call this method to notify user that he has no auth over the resource
  #in this case we redirect to App Login page
  #can be overridden by engines, for example API will just 401
  def access_denied(exception)
    redirect_to  request.referer || root_path, :alert => exception.message
  end

  protected

  def off_public_activity(class_name)
    class_name.public_activity_off
    yield
    class_name.public_activity_on
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
  end

  private

  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status, locals: {exception: exception} }
      format.all { render nothing: true, status: status }
    end
  end

end
