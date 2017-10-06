class BusinessesController < ApplicationController
  # https://www.yelp.com/developers/documentation/v3/business_search
  def index
    request = Yelp::Request.new("businesses", business_params)

    render json: camelize_keys(request.response),
           status: request.valid? ? :ok : :unprocessable_entity
  end

  # https://www.yelp.com/developers/documentation/v3/business
  def show
    request = Yelp::Request.new("business", id: params[:id])

    render json: camelize_keys(request.response),
           status: request.valid? ? :ok : :unprocessable_entity
  end

  private

  # https://www.yelp.com/developers/documentation/v3/business_search
  def business_params
    params.permit(%i[
                    term
                    location
                    latitude
                    longitude
                    radius
                    categories
                    locale
                    limit
                    offset
                    sort_by
                    price
                    open_now
                    open_at
                    attributes
                  ])
  end
end
