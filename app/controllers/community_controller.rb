#encoding: utf-8
class CommunityController < ApplicationController
  def rules

  end

  def about
    @article = Article.where(system_tag: :about).first
  end

  def stats

  end

  def achievement

  end

  def help

  end

  def info
    @article = Article.where(system_tag: params[:system_tag]).first
  end
end
