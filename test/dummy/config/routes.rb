Rails.application.routes.draw do
  mount ActiveStorageDatabase::Engine => "/active_storage_database"

  root "people#index"

  resources :people
end
