Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'

  get  '/roomlist',    to: 'static_pages#roomlist'
  get  '/post',        to: 'static_pages#post'
  get  '/dashboard',   to: 'static_pages#dashboard'
  get  '/signup',      to: 'users#new'
  get  '/login',       to: 'sessions#new'
  post '/login',       to: 'sessions#create'
  delete '/logout',    to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end
  # resources :users #user作成のための7つのURL群を一度に作ってくれる
  # URLが別でも同じページを作成するようにできる。
  resources :account_activations, only: [:edit]
  # アカウント有効化のためのルーティング
  # 7つのアクションの中でのeditだけ作っている。
  # GET /account_activation/<token>/edit
  # tokenの部分に情報が入る。アクセスしたらedit（更新）アクションがはじまる。
  resources :password_resets,     only: %i[new create edit update]
  resources :microposts,          only: %i[create destroy]
  resources :relationships,       only: %i[create destroy]
end
