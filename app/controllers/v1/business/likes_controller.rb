module V1
  module Business
    class LikesController < ApplicationController
      before_action :authenticate_user!

      # POST /businesses/:id/like
      def create
        business = ::Business.find_or_initialize_by(yelp_uid: params[:id])
        like = current_user.business_favorites.find_or_create_by(business: business)

        if like.valid?
          head :created
        else
          render json: { errors: like.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /businesses/:id/like
      def destroy
        business = ::Business.find_or_initialize_by(yelp_uid: params[:id])
        current_user.business_favorites.find_by!(business: business)&.destroy

        head :no_content
      end
    end
  end
end
