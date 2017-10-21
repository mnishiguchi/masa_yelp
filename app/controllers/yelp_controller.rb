class YelpController < ApplicationController
  using ApiConventionRefinements

  # GET /yelp
  # https://www.yelp.com/developers/documentation/v3/business_search
  def businesses
    request = Yelp::Request.new("businesses", yelp_params)

    if request.valid?
      render json: format_response(request.response), status: :ok
    else
      render json: format_response(request.response), status: :unprocessable_entity
    end
  end

  # GET /yelp/:id
  # https://www.yelp.com/developers/documentation/v3/business
  def business
    request = Yelp::Request.new("business", id: params[:id])

    if request.valid?
      render json: format_response(request.response), status: :ok
    else
      render json: format_response(request.response), status: :unprocessable_entity
    end
  end

  # GET /yelp/:id/reviews
  # https://www.yelp.com/developers/documentation/v3/business_reviews
  def reviews
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

  # https://www.yelp.com/developers/documentation/v3/business_search
  def yelp_params
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
