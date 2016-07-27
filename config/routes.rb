Rails.application.routes.draw do
  root "static_pages#home"
  get "contact", to: "static_pages#contact"
  get "help", to: "static_pages#help"

  devise_for :users, controllers: {sessions: "users/sessions",
    omniauth_callbacks: "omniauth_callbacks"}

  resources :users, only: [:show, :edit, :update]
  resources :user_courses, only: [:index, :show] do
    resources :user_subjects, only: [:update, :show]
  end

  namespace :supervisor do
    root "users#index"
    resources :users do
      collection {post :import}
    end
    resources :subjects
    resources :courses do
      resource :user_courses, only: [:update, :edit]
      resource :course_subjects, only: :update
    end
  end
end
