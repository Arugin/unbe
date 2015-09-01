class UserCounterCaches < ActiveRecord::Migration

  def self.up
    add_column :users, :articles_count, :integer, default: 0
    add_column :users, :cycles_count, :integer, default: 0
    add_column :users, :galleries_count, :integer, default: 0
    add_column :users, :contents_count, :integer, default: 0

    User.reset_column_information
    User.find_each do |u|
      User.reset_counters u.id, :articles, :contents, :galleries, :cycles
    end
  end

  def self.down
    remove_column :users, :articles_count
    remove_column :users, :cycles_count
    remove_column :users, :galleries_count
    remove_column :users, :contents_count
  end

end
