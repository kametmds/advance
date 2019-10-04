Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  root :to => 'users#new'
  resources :users do
    collection do
      post :confirm
    end
  end

  #top(User#index)画面からのログイン
  #post '/users', to: 'sessions#create'


  resources :feeds do
    resources :comments
    collection do
      post :confirm
    end
  end

  resources :sessions, only: [:new, :create, :destroy]

  resources :favorites, only: [:index, :create, :destroy]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :relationships, only: [:create, :destroy]
end
