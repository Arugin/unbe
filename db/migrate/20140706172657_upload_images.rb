class UploadImages < Mongoid::Migration
  def self.up
    Article.all.each do |article|
      article.upload_images
      article.save
    end
  end

  def self.down
  end
end