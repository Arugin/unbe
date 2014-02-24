require 'spec_helper'

describe Article do

  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should not publish article if tmpContent nil" do
    article = FactoryGirl.create(:article, author: @user)
    article.publish
    article.isPublished.should be false
  end
end
