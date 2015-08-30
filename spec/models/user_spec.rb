require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should have USER role by default" do
    expect(@user.highest_role).to eq 'USER'
  end

  it "should change to correct role" do
    @user.change_role :ADMIN
    expect(@user.highest_role).to eq 'ADMIN'
  end
end
