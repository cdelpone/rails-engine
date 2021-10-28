Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :revenue do
        resources :merchants, only: [:index, :show]
        resources :items, only: [:index]
      end
      namespace :merchants do
        get '/find_all', to: 'find_all#index'
        get '/most_items', to: 'most_items#index'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      namespace :items do
        get 'find', to: 'find#index'
      end
      resources :items, except: :delete
      get 'items/:id/merchant', to: 'merchants#show'
    end
  end
end
