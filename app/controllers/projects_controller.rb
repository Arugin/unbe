class ProjectsController < ApplicationController
  def index
    @stats = Stats::Base.new
  end
end
