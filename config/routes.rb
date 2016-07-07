Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"
  devise_for :users
end
