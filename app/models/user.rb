class User < ApplicationRecord
  # https://github.com/lynndylanhurley/devise_token_auth#excluding-modules
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable
  # :omniauthable

  include DeviseTokenAuth::Concerns::User

  has_many :business_favorites
end
