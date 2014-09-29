class AddConfirmable < Mongoid::Migration
  def self.up
    User.all.each do |user|
      user.set confirmed_at: Time.zone.now
    end
  end

  def self.down
  end
end