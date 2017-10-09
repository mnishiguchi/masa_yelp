class Business::LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    business = Business.find_or_create_by!(yelp_identifier: params[:id])
    like = current_user.business_favorites.find_or_create_by!(business: business)
    if like.valid?
      head :created
    else
      render json: { errors: like.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    business = Business.find_or_create_by!(yelp_identifier: params[:id])
    current_user.business_favorites.find_by!(business: business)&.destroy
    head :no_content
  end
end
