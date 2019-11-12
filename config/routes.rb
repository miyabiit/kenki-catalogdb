Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'sessions/sign_in', to: 'sessions#new'
  post 'sessions/sign_in', to: 'sessions#create'
  delete 'sessions/sign_out', to: 'sessions#destroy'

  namespace :admin_sessions do
    get :sign_in, to: 'admin_sessions#new'
    post :sign_in, to: 'admin_sessions#create'
    delete :sign_out, to: 'admin_sessions#destroy'
  end

  resources :tests, only: [] do
    collection do
      get :test
    end
  end

  root to: 'tests#test'
end
