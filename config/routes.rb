TravisBickle::Application.routes.draw do
  root :to => 'contents#about_travis'

  resources :documents

  resources :sales

  resources :notifications do
    collection do
      get "api_index"
      put "api_update"
    end
  end

  resources :rests do
    collection do
      post "api_create"
      put "api_update"
    end
  end

  resources :locations do
    collection do
      put "api_update"
    end
  end

  resources :rides do
    collection do
      post "api_create"
      put "api_update"
    end
  end

  resources :reports do
    collection do
      post "api_show"
      post "api_create"
      put "api_update"
    end
  end

  resources :check_points do
    collection do
      get "api_index"
    end
  end

  resources :drivers do
    collection do
      post "api_signin"
      get "api_index"
    end
  end

  resources :cars do
    collection do
      get "api_index"
      put "api_update"
    end
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users
  devise_scope :user do
    # :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
    get "sign_in", :to => "devise/sessions#new"
    get "sign_up", :to => "devise/registrations#new"
    get "sign_out", :to => "devise/sessions#destroy"
    get "/users/auth/:provider", :to => "users/omniauth_callbacks#passthru"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :contents
  resources :users

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match '/:id' => 'contents#show'
  match 'cars/:id/:year/:month' => 'cars#show'
  match 'cars/:id/:year/:month/:day' => 'cars#show'
  match 'drivers/:id/:year/:month' => 'drivers#show'
  match 'drivers/:id/:year/:month/:day' => 'drivers#show'
  match 'sales/:year/:month' => 'sales#index'
  match 'reports/:year/:month/:day' => 'reports#index'
  match 'documents/drivers/:driver_id/:year/:month' => 'documents#index'
  match 'documents/reports/:report_id' => 'documents#show'

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
  # root :to => 'locations#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
