class ActivitiesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource class: 'PublicActivity::Activity'

  def destroy
    @activity = PublicActivity::Activity.find(params[:id])

    message = t :UNABLE_TO_DELETE_ACTIVITY
    begin
      unless @activity.destroy
        redirect_to community_path, alert: message + @activity.errors.full_messages.join(', ')
        return
      end
    rescue => e
      redirect_to community_path, alert: message + e.message
      return
    end
    redirect_to community_path, notice: t(:ACTIVITY_REMOVE_SUCCESS)
  end

end