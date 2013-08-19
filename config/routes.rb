Unbe::Application.routes.draw do

  devise_for :users

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
    end
  end

  resources :cycles

  resources :articles do
    collection do
      get 'news'
      get 'by_area'
    end
    member do
      get 'publish'
      get 'approve'
    end
  end

  resources :projects

  # Office routes
  get '/office', to: 'office#index', as: 'office'
  get '/office/articles', to: 'office#articles',as: 'office_articles'
  get '/office/cycles', to: 'office#cycles',as: 'office_cycles'
  get '/office/articles/non_approved', to: 'office#non_approved',as: 'non_approved_articles'

  # Profile routes
  get '/profile/edit', to: 'profiles#edit',as: 'edit_profile'
  get '/profile/:id', to: 'profiles#user_profile',as: 'user_profile'
  get '/profile/cycles/:id', to: 'profiles#user_cycles',as: 'user_cycles'
  get '/profile/articles/:id', to: 'profiles#user_articles',as: 'user_articles'
  get '/profile/projects/:id', to: 'profiles#user_projects',as: 'user_projects'
  get '/profile/article/:id', to: 'profiles#user_article',as: 'user_article'

  # Community routes
  get '/community/achievement', to: 'community#achievement',as: 'achieving_community'
  get '/community/stats', to: 'community#stats',as: 'stats_community'
  get '/community/about', to: 'community#about',as: 'about_community'
  get '/community/rules', to: 'community#achievement',as: 'rules_community'

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
