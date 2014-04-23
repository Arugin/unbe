class ErrorsController < ApplicationController

  before_filter :select_admin_user

  def error_404
  end

  def error_500
  end

  private

  def select_admin_user
    @admin = User.with_role(:ADMIN).first
  end

end
