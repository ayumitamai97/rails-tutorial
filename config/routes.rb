Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help', as: 'helf' # as: は名前付きルート => helf_pathになる
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
end
