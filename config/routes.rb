Rails.application.routes.draw do
  get 'filters_controller/create'

  get 'filters_controller/update'

  get 'sessions/create'

  get 'sessions/destroy'

  get 'welcome/index'
  
  #match '/auth/dropbox_oauth2/authorize' => 'dropbox#authorize' , :method => :get , :as => :dropbox_auth
  get '/auth/dropbox_oauth2/authorize', to: 'dropbox#authorize'
  #match '/auth/dropbox_oauth2/callback' => 'dropbox#callback' , :method => :get , :as => :dropbox_callback
  get '/auth/dropbox_oauth2/callback', to: 'dropbox#callback'

  get '/auth/evernote_oauth2/authorize', to: 'evernote#authorize'
  get '/auth/evernote_oauth2/callback', to: 'evernote#callback'
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :users
  resources :boards

  resources :widgets
  resources :sources
  resources :filters do
    member do
      post :change_check
    end
  end

  get 'boards/:id/search', to: 'boards#search'
  post 'boards/:id/search', to: 'boards#search'

  get 'dropbox_download/:id/:path', to: 'widgets#dropbox_download'
  match "/delayed_jobs" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  resources :sessions, only: [:create, :destroy]
  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     __END__

  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
