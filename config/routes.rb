Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
      resources :items, except: :delete # do
        # resources :merchants, only: [:show]
      # end
      get '/merchants/find', to: 'search#search_merchant', as: 'merchants/find'
      get '/items/find_all', to: 'search#search_items', as: 'items/find_all'
    end
  end

end
