Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Routes pour les films
  resources :movies do
    resources :bookmarks, only: [:create, :destroy] # Routes imbriquées pour les bookmarks
  end

  # Routes pour les listes
  resources :lists do
    resources :bookmarks, only: [:create, :destroy] # Routes imbriquées pour les bookmarks
  end

  # Routes pour les bookmarks
  resources :bookmarks, only: [:index, :show] # Si vous avez besoin d'une liste ou d'une vue détaillée des bookmarks

  # Routes racine
  root "movies#index" # Ou une autre action que vous souhaitez définir comme racine

  get 'movies/popular', to: 'movies#popular' # Exemple d'une route personnalisée
end
