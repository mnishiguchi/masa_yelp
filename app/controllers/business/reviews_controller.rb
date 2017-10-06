module Business
  class ReviewsController < ApplicationController
    # https://www.yelp.com/developers/documentation/v3/business_reviews
    def index
      request = Yelp::Request.new("business_reviews", id: params[:id])

      render json: camelize_keys(request.response),
             status: request.valid? ? :ok : :unprocessable_entity
    end
  end
end
