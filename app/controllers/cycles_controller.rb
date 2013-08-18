#encoding: utf-8
class CyclesController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:index, :show]

  def index
  end

  def show
    @cycle = Cycle.find(params[:id])
  end

  def new
    @cycle = Cycle.new
  end

  def create
    @cycle = Cycle.new(params[:cycle])
    @cycle.author = current_user

    if @cycle.save
      redirect_to office_cycles_path, notice: t(:CYCLE_CREATE_SUCCESS)
    else
      render action: "new"
    end
  end

  def update
    @cycle = Cycle.find(params[:id])

    if @cycle.system?
      redirect_to office_cycles_path, alert: t('CAN_NOT_EDIT_SYSTEM_CYCLE')
      return
    end

    if @cycle.update_attributes(params[:cycle])
      redirect_to office_cycles_path, notice: t(:CYCLE_UPDATE_SUCCESS)
    else
      render action: "edit"
    end
  end

  def destroy
  end

  def edit
    @cycle = Cycle.find(params[:id])
    if @cycle.system?
      redirect_to office_cycles_path, alert: t('CAN_NOT_EDIT_SYSTEM_CYCLE')
      return
    end
  end
end
