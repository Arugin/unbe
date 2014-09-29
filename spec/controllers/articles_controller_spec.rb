require 'spec_helper'

describe ArticlesController, type: :controller do

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
      FactoryGirl.create(:article, author: @user)
      get :index, {}

      assigns(:articles).should eq []
    end

    it "should not show not approved articles" do
      FactoryGirl.create(:article, author: @user, state: 'Article::Published')

      get :index, {}

      assigns(:articles).should eq []
    end

    it "should not show garbage articles" do
      FactoryGirl.create(:article, author: @user, state: 'Article::Garbage')

      get :index, {}

      assigns(:articles).should eq []
    end

    it "should show approved articles" do
      article = FactoryGirl.create(:article, author: @user, content: 'Daddy', state: 'Article::Approved')

      get :index, {}

      assigns(:articles).should eq [article]
    end
  end

  describe "GET #news" do
    it "responds successfully with an HTTP 200 status code" do
      get :news
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "should show approved to news articles" do
      article = FactoryGirl.create(:article, author: @user, content: 'Daddy', state: 'Article::Approved', to_news: true)

      get :news, {}

      assigns(:articles).should eq [article]
    end

    it "should show approved to news articles" do
      article = FactoryGirl.create(:article, author: @user, content: 'Daddy', state: 'Article::Approved', article_type: ArticleType.where(title: "NEWS").first)

      get :news, {}

      assigns(:articles).should eq [article]
    end
  end

end
