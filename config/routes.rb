Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]

  resources :users

  resources :subs, except: [:destroy]
end
