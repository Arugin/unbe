class ReindexSearch < Mongoid::Migration
  def self.up
    Rake::Task['mongoid_search:index'].invoke
  end

  def self.down
  end
end