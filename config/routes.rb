Rails.application.routes.draw do
  get 'users/new'

  get '/signup', to: 'users#new' #hoge_pathのhogeはuri

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  # get  '/help',    to: 'static_pages#help', as: 'helf' # as: は名前付きルート => helf_pathになる
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
end
