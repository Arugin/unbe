require 'spec_helper'

describe ArticlesController do

  def valid_session
    {}
  end

  before(:each) do
    @user = FactoryGirl.create(:user, gender: @male)
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "should not show not published articles" do
      article = FactoryGirl.create(:article, author: @user)
      get :index, {}

      assigns(:articles).should eq []
    end

    it "should not show not approved articles" do
      article = FactoryGirl.create(:article, author: @user)
      article.publish
      get :index, {}

      assigns(:articles).should eq []
    end

    it "should show approved articles" do
      article = FactoryGirl.create(:article, author: @user, isPublished: true, isApproved: true)
      article.publish
      article.approve
      get :index, {}

      assigns(:articles).should eq [article]
    end
  end
end
