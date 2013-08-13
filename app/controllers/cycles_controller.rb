#encoding: utf-8
class CyclesController < ApplicationController
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
