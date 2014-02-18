#encoding: utf-8
class CommunityController < ApplicationController

  def about
    @article = Article.where(system_tag: :about).first
  end

  def achievement
    @badges = Merit::Badge.find {|b| b.custom_fields[:category] == params[:type] }
  end

  def help

  end

  def info
    @article = Article.where(system_tag: params[:system_tag]).first
  end
end
