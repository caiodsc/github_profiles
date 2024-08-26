# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    member do
      post :reprocess
    end
  end

  resources :short_links, only: :show, path: :s

  root to: 'users#index'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
