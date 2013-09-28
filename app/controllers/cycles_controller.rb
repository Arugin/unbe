#encoding: utf-8
class CyclesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:index, :show]

  respond_to :html, :js

  def index
  end

  def show
    @cycle = Cycle.find(params[:id])
    @comments = @cycle.comments.page(params[:page]).per(15)
    @articles = @cycle.ordered_articles.page(params[:articles_page])
    respond_with @comments
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(params[:cycle])
    @cycle.author = current_user

    if @cycle.save
      redirect_to office_cycles_path(scope:'current_user'), notice: t(:CYCLE_CREATE_SUCCESS)
    else
      render action: "new"
    end
  end

  def update
    @cycle = Cycle.find(params[:id])

    if @cycle.system?
      redirect_to office_cycles_path(scope:'current_user'), alert: t('CAN_NOT_EDIT_SYSTEM_CYCLE')
      return
    end

    if @cycle.update_attributes(params[:cycle])
      redirect_to office_cycles_path(scope:'current_user'), notice: t(:CYCLE_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
    @cycle = Cycle.find(params[:id])

    message = t :UNABLE_TO_DELETE_CYCLE
    begin
      if @cycle.destroy == false
        redirect_to @cycle, alert: message + @cycle.errors.full_messages.join(', ')
        return
      end
    rescue Exception => e
      redirect_to @cycle, alert: message + e.message
      return
    end
    redirect_to office_cycles_path(scope:'current_user'), notice: t(:CYCLE_REMOVE_SUCCESS)
  end

  def edit
    @cycle = Cycle.find(params[:id])
    if @cycle.system?
      redirect_to office_cycles_path(scope:'current_user'), alert: t('CAN_NOT_EDIT_SYSTEM_CYCLE')
      return
    end
  end
end
