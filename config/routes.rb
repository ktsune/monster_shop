Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # => root
  # get '/', to: 'welcome#index', as: :root

  # => rewritten root
  root to: "welcome#index"

  # => admin routes
  # get '/admin/merchants', to: 'admin/merchants#index', as: :admin_merchant_index
  # get '/admin/merchants/new', to: 'admin/merchants#new', as: :new_merchant => Merchant controller errors
  # post '/merchants', to: 'admin/merchants#create', as: :create_merchant
  # patch '/merchants/:id', to: 'admin/merchants#update'
  # delete '/merchants/:id', to: 'admin/merchants#destroy', as: :delete_merchant
  # get '/merchants/:id/edit', to: 'admin/merchants#edit', as: :edit_merchant
  # get '/admin/merchants/:id', to: 'admin/merchants#show', as: :admin_merchant_show

  # => rewritten admin routes
  namespace :admin do
    resources :merchants, only: [:index, :new, :show]
  end

  # => rewritten admin routes
  scope module: 'admin' do
    resources :merchants, only: [:create, :update, :edit, :destroy]
  end

  # => admin manipulates a merchants items
  # get '/admin/merchants/:merchant_id/items', to: 'admin/items#index', as: :admin_merchant_items
  # get 'admin/merchants/:merchant_id/items/new', to: 'admin/items#new', as: :admin_new_item
  # get 'admin/merchants/:merchant_id/items/:id/edit', to: 'admin/items#edit', as: :admin_edit_item
  # patch 'admin/merchants/:merchant_id/items/:id/edit', to: 'admin/items#update', as: :admin_update_item
  # post 'admin/merchants/:merchant_id/items', to: 'admin/items#create', as: :admin_create_item
  # delete 'admin/merchants/:merchant_id/items/:id/delete', to: 'admin/items#destroy', as: :admin_delete_item
  post 'admin/merchants/:merchant_id/items/:id/deactivate', to: 'admin/items#deactivate', as: :admin_disable_item
  post 'admin/merchants/:merchant_id/items/:id/activate', to: 'admin/items#activate', as: :admin_enable_item
  patch '/admin/orders/:order_id/items/:id', to: 'admin/items#fulfill', as: :admin_fulfill

  # => rewritten admin manipulates a merchants items
  namespace :admin, as: :admin do
    resources :merchants do
      resources :items, only: [:index, :new, :edit, :update, :create, :destroy]
    end
  end

  # => merchants
  # resources :merchants, only: [:index, :show] do
  #   resources :items, only: [:index]
  # end

  # => rewritten merchants routes
  get '/merchants', to: 'merchants#index'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:merchant_id/items', to: 'items#index', as: :merchant_items

  # => items
  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end

  # => rewritten items & nested reviews routes
  get '/items', to: 'items#index', as: :items
  get '/items/:id', to: 'items#show', as: :item
  get '/items/:item_id/reviews/new', to: 'reviews#new', as: :new_item_review
  post '/items/:item_id/reviews', to: 'reviews#create', as: :item_reviews

  # => reviews
  # resources :reviews, only: [:edit, :update, :destroy]

  # => rewritten reviews
  get '/reviews/:id/edit', to: 'reviews#edit', as: :edit_review
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy', as: :review

  # => cart
  get '/cart', to: 'cart#show', as: :cart_path
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  # => orders
  # resources :orders, only: [:new, :destroy]

  # => rewritten orders
  get '/orders', to: 'orders#new', as: :new_order
  delete '/orders/:id', to: 'orders#destroy', as: :order

  # => users
  # resources :users, only: [:create, :show, :edit, :update]

  # => rewritten users
  get '/users/:id', to: 'users#show'
  patch '/users/:id', to: 'users#update'
  get '/users/:id/edit', to: 'users#edit'
  post '/users', to: 'users#create'

  # => profile
  get '/profile', to: 'users#show', as: :profile
  get '/profile/edit', to: 'users#edit', as: :profile_edit
  patch '/profile/edit', to: 'users#update'

  # => pull up past & current orders for a user
  # scope :profile, as: :profile do
  #   resources :orders, only: [:index, :show, :create]
  # end

  # => rewritten profile orders
  post '/profile/orders', to: 'orders#create', as: :create_order
  get '/profile/orders', to: 'orders#index', as: :profile_orders
  get '/profile/orders/:id', to: 'orders#show', as: :show_order

  # => merchant
  # get '/merchant/orders/:id', to: 'merchant/orders#show', as: :merchant_orders
  get '/merchant', to: 'merchant/orders#index', as: :merchant_dashboard
  patch '/merchant/orders/:order_id/items/:id', to: 'merchant/items#fulfill', as: :fulfill

  # => rewritten merchant
  namespace :merchant do
    resources :orders, only: [:show]
  end

  # scope :merchant, module: :orders, as: :merchant_dashboard do
  #   resources :orders, only: [:index]
  # end

  # => admin
  # patch '/admin/order/:id', to: 'admin/orders#update', as: :admin_ships_order
  # get '/admin/users', to: 'admin/users#index', as: :admin_user_index
  # get '/admin/users/:id', to: 'admin/users#show', as: :admin_user_show
  # get '/admin/user/:id/edit', to: 'admin/users#edit', as: :admin_user_edit
  # patch '/admin/users/:id', to: 'admin/users#update'
  get '/admin/dashboard', to: 'admin/orders#index', as: :admin_dashboard
  get '/admin/users/:user_id/orders/:order_id', to: 'admin/orders#show', as: :admin_user_order
  delete '/admin/users/:user_id/orders/:order_id', to: 'admin/orders#destroy', as: :admin_cancels_user_order
  patch '/admin/merchants/:id/enable', to: 'admin/merchants#enable', as: :enable_merchant
  patch '/admin/merchants/:id/disable', to: 'admin/merchants#disable', as: :disable_merchant
  patch '/admin/users/:user_id/enable', to: 'admin/users#enable', as: :enable_user
  patch '/admin/users/:user_id/disable', to: 'admin/users#disable', as: :disable_user

  # => rewritten admin
  namespace :admin, as: :admin do
    resources :orders, only: [:update]
    resources :users, only: [:index, :show, :edit, :update]
  end

  # => rewritten admin orders
  # namespace :admin, module: :admin do
  #   resources :users do
  #     resources :orders, only: [:show, :destroy]
  #   end
  # end

  # => user registration & logging in
  get '/register', to: 'users#new', as: :register
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'

  # => merchant items dashboard
  # get '/dashboard/items', to: 'merchant/items#index', as: :dashboard_items
  # get '/dashboard/items/new', to: 'merchant/items#new', as: :new_item
  # get '/dashboard/items/:id/edit', to: 'merchant/items#edit', as: :edit_item
  # patch '/dashboard/items/:id/edit', to: 'merchant/items#update', as: :update_item
  # post '/dashboard/items', to: 'merchant/items#create', as: :create_item
  # delete '/dashboard/items/:id/delete', to: 'merchant/items#destroy', as: :delete_item
  post '/dashboard/items/:id/deactivate', to: 'merchant/items#deactivate', as: :disable_item
  post '/dashboard/items/:id/activate', to: 'merchant/items#activate', as: :enable_item

  # => rewritten merchant items dashboard
  scope :dashboard, module: :merchant, as: :dashboard do
    resources :items, only: [:index]
  end

  scope :dashboard, module: :merchant do
    resources :items, only: [:new, :edit]
  end

  scope :dashboard, module: :merchant, as: :update do
    resources :items, only: [:update]
  end

  scope :dashboard, module: :merchant, as: :create do
    resources :items, only: [:create]
  end

  scope :dashboard, module: :merchant, as: :delete do
    resources :items, only: [:destroy]
  end

  # => dashboard
  # scope :dashboard, as: :dashboard do
  #   resources :orders, only: :show
  # end

  # => rewritten dashboard
  get '/dashboard/orders/:id', to: 'orders#show', as: :dashboard_order

  get '*path', to: 'welcome#error404'
end
