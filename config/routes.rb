Rails.application.routes.draw do
  get 'users/new'

  get '/signup', to: 'users#new' #hoge_pathのhogeはuri

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  # get  '/help',    to: 'static_pages#help', as: 'helf' # as: は名前付きルート => helf_pathになる
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  resources :users # ユーザー情報を表示するURL (/users/1) を追加するためだけのものではありません。サンプルアプリケーションにこの１行を追加すると、ユーザーのURLを生成するための多数の名前付きルート (5.3.3) と共に、RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになるのです。
end
