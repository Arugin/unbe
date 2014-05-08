#encoding: utf-8
class CommunitiesController < ApplicationController

  def show
    @activities = PublicActivity::Activity.all.order_by(created_at: :desc).page(params[:page]).per(20)
  end

  def about
    @article = Article.where(system_tag: :about).first
  end

  def achievements
    @badges = Merit::Badge.find {|b| b.custom_fields[:category].to_s == params[:type].to_s}
  end

  def help

  end

  def info
    @article = Article.where(system_tag: params[:system_tag]).first
  end

end
