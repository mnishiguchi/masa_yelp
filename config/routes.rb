Rails.application.routes.draw do
  # Authentication
  # https://github.com/lynndylanhurley/devise_token_auth#mounting-routes
  mount_devise_token_auth_for "User", at: "auth"
  as :user do
    # Define routes for User within this block.
  end

  # Yelp api wrapper
  get "yelp"             => "yelp#businesses", as: :yelp_businesses
  get "yelp/:id"         => "yelp#business",   as: :yelp_business
  get "yelp/:id/reviews" => "yelp#reviews",    as: :yelp_business_reviews

  # Custom api
  namespace :v1 do
    resources :businesses, only: [:index, :show] do
      member do
        resources :reviews, only: [:index], module: :business, as: :business_reviews
        # Only one like is allowed per post per user.
        resource :like, only: [:create, :destroy], module: :business, as: :business_like
      end
    end
  end

  root "v1/businesses#index"
end
