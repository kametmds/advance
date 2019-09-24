Rails.application.routes.draw do

  resources :users do
    collection do
      post :confirm
    end
  end
  #top(User#index)画面からのログイン
  post '/users', to: 'sessions#create'

  resources :feeds do
    collection do
      post :confirm
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :favorites, only: [:create, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
