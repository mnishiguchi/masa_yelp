module V1
  class BusinessesController < ApplicationController
    # GET /v1/businesses
    # GET /v1/businesses?q[rating_gt]=3
    # GET /v1/businesses?q[price_lt]=3
    # GET /v1/businesses?q[categories_cont]=bbq
    # GET /v1/businesses?location=white-house
    # GET /v1/businesses?latitude=38.0877&longitude=-77.0365
    # GET /v1/businesses?within=30&location=white-house
    # GET /v1/businesses?within=30&latitude=38.0877&longitude=-77.0365
    # GET /v1/businesses?per_page=3
    def index
      # The q param is expected to be a hash with ransack search matchers as keys. https://github.com/activerecord-hackery/ransack
      q = find_businesses_by_location.ransack(params[:q])
      businesses = q.result.page(params[:page]).per(params[:per_page] || 25).to_a.uniq

      render json: Surrealist.surrealize_collection(businesses || [], camelize: true)
    end

    # GET /v1/businesses/:id
    def show
      business = ::Business.find_by(yelp_uid: params[:id])

      if business.present?
        render json: business.surrealize(camelize: true), status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    def find_businesses_by_location
      within || by_distance || ::Business
    end

    def within
      return if params[:within].blank?

      if params[:location]
        ::Business.within(distance, origin: params[:location])
      elsif params[:latitude] && params[:longitude]
        ::Business.within(params[:within], origin: params.values_at(:latitude, :longitude))
      end
    end

    def by_distance
      return if params[:within].present?

      if params[:location]
        ::Business.by_distance(origin: params.dig(:location))
      elsif params[:latitude] && params[:longitude]
        ::Business.by_distance(origin: params.values_at(:latitude, :longitude))
      end
    end
  end
end
