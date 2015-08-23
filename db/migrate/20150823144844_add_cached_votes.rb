class AddCachedVotes < ActiveRecord::Migration
  def self.up
    add_column :articles, :cached_votes_total, :integer, default: 0
    add_column :articles, :cached_votes_up, :integer, default: 0
    add_column :articles, :cached_votes_down, :integer, default: 0

    add_index  :articles, :cached_votes_total
    add_index  :articles, :cached_votes_up
    add_index  :articles, :cached_votes_down
  end

  def self.down
    remove_column :articles, :cached_votes_total
    remove_column :articles, :cached_votes_up
    remove_column :articles, :cached_votes_down
  end
end
