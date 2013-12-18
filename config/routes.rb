TravisBickle::Application.routes.draw do
  root :to => 'contents#about_travis'

  resources :pickup_locations

  resources :documents

  resources :notifications

  resources :rests

  resources :locations

  resources :rides

  resources :reports

  resources :check_points

  resources :drivers

  resources :cars

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
  resources :users, constraints: { id: /[^\/]+/ }

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match '/:id' => 'contents#show'
  match 'cars/:id/:year/:month' => 'cars#show'
  match 'cars/:id/:year/:month/:day' => 'cars#show'
  match 'drivers/:id/:year/:month' => 'drivers#show'
  match 'drivers/:id/:year/:month/:day' => 'drivers#show'
  match 'reports/:year/:month' => 'reports#daily'
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
  namespace :api do
    resources :cars, :check_points, :locations, :notifications, :reports, :rests, :rides

    resources :drivers do
      collection do
        post "signin"
      end
    end
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  # root :to => 'locations#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
