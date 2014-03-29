require 'spec_helper'

describe Article do

  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should not publish article if tmpContent nil" do
    article = FactoryGirl.create(:article, author: @user)
    article.publish
    article.published?.should be false
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

  it "should publish article if tmpContent present"  do
    article = FactoryGirl.create(:article, author: @user, tmpContent: 'Some content here')
    article.publish
    article.published?.should be true
  end

  it "should publish article if tmpContent present"  do
    tmpContent = 'Some content here'
    article = FactoryGirl.create(:article, author: @user, tmpContent: tmpContent, state: 'Article::Published')
    article.approve
    article.approved?.should be true
    article.content.should eq tmpContent
  end

  it "should move article to changed if it's content changed" do
    article = FactoryGirl.create(:article, author: @user, content: 'Some content here', state: 'Article::Approved')
    article.tmpContent = 'Daddy'
    article.to_changed
    article.approved?.should be true
    article.is_updated?.should be true
    article.published?.should be false
  end

  it "should not move article to changed if it's content not changed" do
    article = FactoryGirl.create(:article, author: @user, content: 'Some content here', state: 'Article::Approved')
    article.tmpContent = 'Some content here'
    article.to_changed
    article.is_updated?.should be false
    article.tmpContent.should be nil
  end

  it "should publish changed article, but marked it as changed", :focus => true do
    article = FactoryGirl.create(:article, author: @user, content: 'Some content here', tmpContent: 'Daddy', state: 'Article::Changed')
    article.publish
    article.is_updated?.should be true
    article.published?.should be true
  end

  it "should move article to garbaget"  do
    tmpContent = 'Some content here'
    article = FactoryGirl.create(:article, author: @user, tmpContent: tmpContent, state: 'Article::Published')
    article.to_garbage
    article.approved?.should be true
    article.garbage?.should be true
    article.content.should eq tmpContent
  end
end
