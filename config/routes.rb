# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  # Minimal auth for pet project — only sign in, sign out, sign up
  devise_for :users, skip: :all

  as :user do
    devise_scope :user do
      get    'users/sign_in',  to: 'devise/sessions#new',     as: :new_user_session
      post   'users/sign_in',  to: 'devise/sessions#create',  as: :user_session
      delete 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session

      get    'users/sign_up',  to: 'devise/registrations#new',    as: :new_user_registration
      post   'users',          to: 'devise/registrations#create', as: :user_registration
    end
  end

  resources :notes

  resources :stopwatches, only: %i[index create destroy] do
    patch :stop, on: :member
  end

  resources :timers, only: %i[index create destroy] do
    patch :stop, on: :member
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
