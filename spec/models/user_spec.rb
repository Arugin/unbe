require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should have USER role by default" do
    @user.highest_role.should eq 'USER'
  end

  it "should change to correct role" do
    @user.change_role :ADMIN
    @user.highest_role.should eq 'ADMIN'
  end
end
