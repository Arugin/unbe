require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "title and name should be eq" do
    gallery = FactoryGirl.create(:gallery, author: @user)
    expect(gallery.title).to eq gallery.name
  end
end
