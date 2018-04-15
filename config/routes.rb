Rails.application.routes.draw do

  root 'static_pages#home'
  get '/signup', to: 'users#new' #hoge_pathのhogeはuri
  post '/signup', to: 'users#create' #hoge_pathのhogeはuri
  get  '/help',    to: 'static_pages#help'
  # get  '/help',    to: 'static_pages#help', as: 'helf' # as: は名前付きルート => helf_pathになる
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  resources :users
   # ユーザー情報を表示するURL (/users/1) を追加するためだけのものではありません。サンプルアプリケーションにこの１行を追加すると、ユーザーのURLを生成するための多数の名前付きルート (5.3.3) と共に、RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになるのです。
   resources :account_activations, only: [:edit] # アクションの追加
end
