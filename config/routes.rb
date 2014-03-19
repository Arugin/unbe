Unbe::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  resources :users do
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
    end
    member do
      get 'publish'
      get 'approve'
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
    end
    member do
      get 'articles'
      get 'cycles'
      get 'galleries'
    end
  end

  # Office routes
  get '/office/articles/non_approved', to: 'offices#non_approved',as: 'non_approved_articles'
  get '/office/content/non_approved', to: 'offices#non_approved_content',as: 'non_approved_contents'

  # Profile routes
  get '/profile/edit', to: 'profiles#edit',as: 'edit_profile'
  get '/profile/:id', to: 'profiles#user_profile',as: 'user_profile'
  get '/profile/cycles/:id', to: 'profiles#user_cycles',as: 'user_cycles'
  get '/profile/articles/:id', to: 'profiles#user_articles',as: 'user_articles'
  get '/profile/projects/:id', to: 'profiles#user_projects',as: 'user_projects'
  get '/profile/article/:id', to: 'profiles#user_article',as: 'user_article'
  get '/profile/galleries/:id', to: 'profiles#user_galleries',as: 'user_galleries'

  # Community routes
  get '/community/achievement', to: 'community#achievement',as: 'achieving_community'
  get '/community/stats', to: 'community#stats',as: 'stats_community'
  get '/community/about', to: 'community#about',as: 'about_community'
  get '/community/rules', to: 'community#rules',as: 'rules_community'
  get '/community/info', to: 'community#info',as: 'info_community'

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => "articles#news"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  devise_scope :user do
    root :to => 'devise/sessions#new'
  end
end
