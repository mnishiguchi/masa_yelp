module V1
  module Business
    class ReviewsController < ApplicationController
      using ApiConventionRefinements

      def index
        request = Yelp::Request.new("business_reviews", id: params[:id])

        if request.valid?
          render json: format_response_data(request.response), status: :ok
        else
          render json: format_response_error(request.response), status: :unprocessable_entity
        end
      end

      private

      def format_response_data(response)
        response[:reviews].map do |review|
          review.slice(:url, :text, :rating, :user, :timeCreated).camelize_keys
        end
      end

      def format_response_error(response)
        response.camelize_keys
      end
    end
  end
end
