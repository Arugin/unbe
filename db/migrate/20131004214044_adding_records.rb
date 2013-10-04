class AddingRecords < Mongoid::Migration
  def self.up
    ArticleArea.create ({:title => :INDUSTRY})
    ArticleType.create ({:title => 'STORY'})
    ArticleType.create ({:title => 'REVIEW'})
  end

  def self.down
  end
end