Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'sessions/sign_in', to: 'sessions#new'
  post 'sessions/sign_in', to: 'sessions#create'
  delete 'sessions/sign_out', to: 'sessions#destroy'

  get 'admin_sessions/sign_in', to: 'admin_sessions#new'
  post 'admin_sessions/sign_in', to: 'admin_sessions#create'
  delete 'admin_sessions/sign_out', to: 'admin_sessions#destroy'

  get 'api_test', to: 'api_test#index'

  resources :tests, only: [] do
    collection do
      get :test
    end
  end

  resources :companies
  resources :categories do
    member do
      get :add_child
      get :edit_child
    end
    collection do
      get :import
      post :import, to: 'categories#upload'
    end
  end
  resources :sub_categories
  resources :products do
    resources :stock_products
    collection do
      get :import
      post :import, to: 'products#upload'
    end
  end
  resources :staffs

  resources :text_props
  resources :image_props
  resources :file_props

  resources :stock_products do
    resources :chartered_stock_products
    collection do
      get :import
      post :import, to: 'stock_products#upload'
    end
  end
  resources :other_stock_products, only: [:index, :show]
  resources :chartered_stock_products

  namespace :api do
    resources :companies do
      collection do
        post :search, action: :index
      end
    end
    resources :categories do
      collection do
        post :search, action: :index
      end
    end
    resources :staffs do
      collection do
        post :search, action: :index
      end
    end
    resources :sub_categories do
      collection do
        post :search, action: :index
      end
    end
    resources :file_props do
      collection do
        post :search, action: :index
      end
    end
    resources :text_props do
      collection do
        post :search, action: :index
      end
    end
    resources :image_props do
      collection do
        post :search, action: :index
      end
    end
    resources :products do
      collection do
        post :search, action: :index
      end
    end
    resources :tokens, only: [:create]
    resources :stock_products do
      collection do
        post :search, action: :index
      end
    end
    resources :chartered_stock_products do
      collection do
        post :search, action: :index
      end
    end
  end

  root to: 'tests#test'

  # suppress routing error
  get '*path', to: 'not_found#not_found', constraints: InvalidRequestConstraint.new
end
