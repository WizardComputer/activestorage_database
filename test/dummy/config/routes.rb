Rails.application.routes.draw do
  mount ActivestorageDatabase::Engine => "/activestorage_database"

  root "people#index"

  resources :people
end
