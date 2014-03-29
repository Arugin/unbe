class ArticleState < Mongoid::Migration
  def self.up
    Article.all.each do |article|
      if article.isApproved && article.isPublished && !article.isUpdated && !article.is_garbage
        article.set :state, 'Article::Approved'
      elsif !article.isApproved && article.isPublished
        article.set :state, 'Article::Published'
      elsif article.isApproved && article.is_garbage
        article.set :state, 'Article::Garbage'
      else
        article.set :state, 'Article::Initial'
      end
      article.unset :isApproved
      article.unset :isPublished
      article.unset :isUpdated
      article.unset :is_garbage
    end
  end

  def self.down
  end
end