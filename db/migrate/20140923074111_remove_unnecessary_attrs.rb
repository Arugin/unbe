class RemoveUnnecessaryAttrs < Mongoid::Migration
  def self.up
    Article.all.each do |article|
      article.unset :publish
      article.unset :approve
    end
  end

  def self.down
  end
end