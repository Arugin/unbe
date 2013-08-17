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
  end

  def create
  end

  def update
  end

  def destroy
  end
end
