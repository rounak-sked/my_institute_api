Rails.application.routes.draw do
  # Devise routes (JWT + mapping)
  devise_for :users,
             defaults: { format: :json },
             controllers: {
               sessions: "users/sessions"
             }

  # Custom auth endpoints
  devise_scope :user do
    post   "/signup", to: "users/registrations#create"
    post   "/login",  to: "users/sessions#create"
    delete "/logout", to: "users/sessions#destroy"
  end

  # Test auth
  get "/test", to: "test#index"

  # Courses (CanCan protected)
  resources :courses, only: [:index, :create]
  resources :batches, only: [:index, :create]
  resources :enrollments, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end
  namespace :api do
  namespace :v1 do
    resources :courses, only: [:index, :create, :update, :destroy]
    resources :batches, only: [:index, :create, :update, :destroy]
    resources :enrollments, only: [:index,:create] do
      member do
        patch :approve
        patch :reject
      end
    end
  end
end
end

