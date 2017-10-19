class ApplicationController < ActionController::API
  # https://github.com/lynndylanhurley/devise_token_auth#controller-methods
  include DeviseTokenAuth::Concerns::SetUserByToken
end
