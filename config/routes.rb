Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  resources :projects

  namespace :admin do
    resources :users do
      post :bulk_upload, on: :collection
    end

    resources :roles
  end

  get 'resource_metadata/select_options'

  root to: 'projects#index'
end
