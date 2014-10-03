class AddSettingsToUser < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.create_settings
    end
  end

  def self.down
  end
end