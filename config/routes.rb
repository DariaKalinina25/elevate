# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  resources :notes

  resources :stopwatches, only: %i[index create destroy] do
    member do
      patch :stop
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
