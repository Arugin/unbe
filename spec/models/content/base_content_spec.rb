require 'spec_helper'

describe Content do
  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should be valid if valid youtube url was set" do
    @content = Content.new(src: 'http://www.youtube.com/watch?v=zqrBkgrzLik')
    @content.author = @user
    @content.valid?.should be true
  end

  it "should be valid if valid vimeo url was set" do
    @content = Content.new(src: 'http://vimeo.com/87452228', author: @user)
    @content.author = @user
    @content.valid?.should be true
  end

  it "should not save content, if url not vimeo or youtube" do
    @content = Content.new(src: 'http://cs605422.vk.me/v605422059/4186/q1S5uu4hsRE.jpg', author: @user)
    @content.author = @user
    @content.valid?.should be false
  end
end
