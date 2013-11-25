class AddingSlug < Mongoid::Migration
  def self.up
    Article.all.each do |article|
      article.set :title, article.title
      article.save!
    end
    Cycle.all.each do |cycle|
      cycle.set :title, cycle.title
      cycle.save!
    end
    Gallery.all.each do |gallery|
      gallery.set :name, gallery.name
      gallery.save!
    end
    User.all.each do |user|
      user.set :name, user.name
      user.save!
    end
    Content::BaseContent.all.each do |content|
      content.set :title, content.title
      content.save!
    end
  end

  def self.down
  end
end