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

  it "should truncate the content when unbebreak exists" do
    article = FactoryGirl.create(:article, author: @user, tmpContent: '<p>daddy</p><p><!-- unbebreak --></p>')
    article.publish
    article.approve
    article.short_content.length.should eq 12
  end

  it "should truncate the content when unbebreak exists and p have trash" do
    article = FactoryGirl.create(:article, author: @user, tmpContent: "<p alighn='center'>daddy</p><p><!-- unbebreak --></p>")
    article.publish
    article.approve
    article.short_content.length.should eq 28
  end

  it "should do nothing if no unbebreak in content or it's not a comment" do
    article = FactoryGirl.create(:article, author: @user, tmpContent: '<p>daddy</p><p>unbebreak</p><daddy/>')
    article.publish
    article.approve
    article.short_content.length.should eq 36
  end
end
