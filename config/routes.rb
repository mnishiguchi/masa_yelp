Rails.application.routes.draw do
  resources :businesses, only: [:index, :show] do
    member do
      resources :reviews, only: [:index], module: :business, as: :business_reviews
    end
  end

  root "businesses#index"
end
