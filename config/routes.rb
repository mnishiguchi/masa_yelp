Rails.application.routes.draw do
  resources :businesses, only: [:index, :show] do
    member do
      resources :reviews, only: [:index], module: :business, as: :business_reviews
    end
  end

  # https://github.com/lynndylanhurley/devise_token_auth#mounting-routes
  mount_devise_token_auth_for "User", at: "auth"
  as :user do
    # Define routes for User within this block.
  end

  root "businesses#index"
end
