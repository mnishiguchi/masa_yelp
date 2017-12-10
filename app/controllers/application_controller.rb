class ApplicationController < ActionController::API
  # https://github.com/lynndylanhurley/devise_token_auth#controller-methods
  include DeviseTokenAuth::Concerns::SetUserByToken

  include RespondsWithError

  # Deliver errors in a single, unified format with clear, useful information.
  rescue_from ActiveRecord::RecordNotFound, with: :respond_with_not_found
end
