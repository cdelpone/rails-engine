Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      resources :items, except: :delete
      get '/items/:id/merchant', to: 'merchants#show'

    end
  end
end
