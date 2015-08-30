require 'spec_helper'

describe Article do

  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  it "should not publish article if tmp_content nil" do
    article = FactoryGirl.create(:article, author: @user)
    article.publish
    expect(article.published?).to be false
  end

  it "should truncate the content when unbebreak exists" do
    article = FactoryGirl.create(:article, author: @user, tmp_content: '<p>daddy</p><p><!-- unbebreak --></p>')
    article.publish
    article.approve
    expect(article.short_content.length).to eq 12
  end

  it "should truncate the content when unbebreak exists and p have trash" do
    article = FactoryGirl.create(:article, author: @user, tmp_content: "<p alighn='center'>daddy</p><p><!-- unbebreak --></p>")
    article.publish
    article.approve
    expect(article.short_content.length).to eq 28
  end

  it "should do nothing if no unbebreak in content or it's not a comment" do
    tmp_content = '<noo><p>daddy</p><p>unbebreak</p><daddy></daddy></noo>'
    article = FactoryGirl.create(:article, author: @user, tmp_content: tmp_content)
    article.publish
    article.approve
    expect(article.short_content).to eq tmp_content
  end

  it "should publish article if tmp_content present"  do
    article = FactoryGirl.create(:article, author: @user, tmp_content: 'Some content here')
    article.publish
    expect(article.published?).to be true
  end

  it "should publish article if tmp_content present"  do
    tmp_content = '<p>Some content here</p>'
    article = FactoryGirl.create(:article, author: @user, tmp_content: tmp_content, state: 'Article::Published')
    article.approve
    expect(article.approved?).to be true
    expect(article.clean_content).to eq tmp_content
  end

  it "should move article to changed if it's content changed" do
    article = FactoryGirl.create(:article, author: @user, content: 'Some content here', state: 'Article::Approved')
    article.tmp_content = 'Daddy'
    article.to_changed
    expect(article.approved?).to be true
    expect(article.is_updated?).to be true
    expect(article.published?).to be false
  end

  it "should not move article to changed if it's content not changed" do
    article = FactoryGirl.create(:article, author: @user, content: '<p>Some content here</p>', state: 'Article::Approved')
    article.tmp_content = '<p>Some content here</p>'
    article.to_changed
    expect(article.is_updated?).to be false
    expect(article.tmp_content).to be nil
  end

  it "should publish changed article, but marked it as changed", :focus => true do
    article = FactoryGirl.create(:article, author: @user, content: 'Some content here', tmp_content: 'Daddy', state: 'Article::Changed')
    article.publish
    expect(article.is_updated?).to be true
    expect(article.published?).to be true
  end

  it "should move article to garbaget"  do
    tmp_content = '<p>Some content here</p>'
    article = FactoryGirl.create(:article, author: @user, tmp_content: tmp_content, state: 'Article::Published')
    article.to_garbage
    expect(article.approved?).to be true
    expect(article.garbage?).to be true
    expect(article.clean_content).to eq tmp_content
  end
end
