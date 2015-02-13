Unbe::Application.routes.draw do

  get '/auth/:provider/callback' => 'authentications#create'

  resources :authentications

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users do
    collection do
      get 'email'
      post 'email', action: :omni_save
    end
    member do
      get 'change_role'
      get 'block'
    end
  end

  resources :cycles do
    resources :comments
    collection do
      get 'bulk_delete'
      get 'bulk_tag'
    end
  end

  resources :galleries do
    resources :contents, as: :content_base_contents, controller: :contents, shallow: true
    resources :comments
  end
  resources :contents, as: :content_base_contents do
    resources :comments
    member do
      get 'approve'
      get 'vote_up'
      get 'vote_down'
    end
  end


  resources :articles do
    collection do
      get 'news'
      get 'new_news'
      get 'garbage'
      get 'bulk_delete'
      get 'bulk_tag'
      get 'feed'
    end
    member do
      get 'publish'
      get 'approve'
      get 'to_main'
      get 'vote_up'
      get 'vote_down'
      get 'draft'
      get 'to_garbage'
    end
    resources :comments
  end

  resources :comments do
    member do
      get 'vote_up'
      get 'vote_down'
    end
  end


  resources :projects

  resource :office do
    collection do
      get 'assign_badges', action: :assign_badges_show
      post 'assign_badges', action: :assign_badges_update
      get 'add_points', action: :add_points_show
      post 'add_points', action: :add_points_update
    end
    member do
      get 'articles'
      get 'cycles'
      get 'galleries'
      get 'settings'
      get 'subscriptions'
      get 'non_approved_articles'
      get 'non_approved_contents'
    end
  end

  resources :profiles do
    member do
      get 'articles'
      get 'article'
      get 'cycles'
      get 'galleries'
      get 'projects'
      get 'comments'
      get 'subscribe'
      get 'unsubscribe'
    end
  end

  resource :community do
    member do
      get 'achievements'
      get 'stats'
      get 'about'
      get 'rules'
      get 'info'
    end
  end

  resources :activities, only: [:destroy], as: :public_activity_activity


  root to: "articles#news"

  get '*not_found', to: 'errors#error_404', via: :get
end
