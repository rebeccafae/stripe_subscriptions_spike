Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resources :charges
  resources :subscriptions
end
