Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"

  devise_for :users, controllers: {sessions: "users/sessions"}

  resources :user_courses, only: :index

  namespace :supervisor do
    root "users#index"
    resources :users
    resources :subjects
    resources :courses do
      resource :user_courses, only: [:update, :edit]
      resource :course_subjects, only: :update
    end
  end
end
