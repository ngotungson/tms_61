Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"

  devise_for :users, controllers: {sessions: "users/sessions"}

  namespace :supervisor do
    root "users#index"
    resources :users
    resources :courses
    resources :subjects
  end
end
