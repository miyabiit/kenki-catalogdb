Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'sessions/sign_in', to: 'sessions#new'
  post 'sessions/sign_in', to: 'sessions#create'
  delete 'sessions/sign_out', to: 'sessions#destroy'

  get 'admin_sessions/sign_in', to: 'admin_sessions#new'
  post 'admin_sessions/sign_in', to: 'admin_sessions#create'
  delete 'admin_sessions/sign_out', to: 'admin_sessions#destroy'

  resources :tests, only: [] do
    collection do
      get :test
    end
  end

  resources :companies

  root to: 'tests#test'
end
