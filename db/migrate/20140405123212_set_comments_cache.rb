class SetCommentsCache < Mongoid::Migration
  def self.up
    [Article, Cycle, Gallery, Content::BaseContent, User].each do |item|
      item.all.each do |model|
        item.update_counters(model.id, comments_count: model.comments.count)
      end
    end
  end

  def self.down
  end
end