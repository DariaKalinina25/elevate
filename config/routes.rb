# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, only: [:sessions, :registrations]

  resources :notes

  resources :stopwatches, only: %i[index create destroy] do
    patch :stop, on: :member
  end

  resources :timers, only: %i[index create destroy] do
    patch :stop, on: :member
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
