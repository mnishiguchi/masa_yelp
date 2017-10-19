module Yelp
  class ReviewsController < ApplicationController
    using ApiConventionRefinements

    # https://www.yelp.com/developers/documentation/v3/business_reviews
    def index
      request = Yelp::Request.new("business_reviews", id: params[:id])

      if request.valid?
        render json: format_response(request.response), status: :ok
      else
        render json: format_response(request.response), status: :unprocessable_entity
      end
    end

    private

    def format_response(response)
      response.camelize_keys
    end
  end
end
