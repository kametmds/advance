Rails.application.routes.draw do

  resources :users do
    collection do
      post :confirm
    end
  end

  post '/users', to: 'sessions#create'

  resources :feeds do
    collection do
      post :confirm
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  
end
