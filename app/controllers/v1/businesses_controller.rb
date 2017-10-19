module V1
  class BusinessesController < ApplicationController
    # GET /businesses
    def index
      # TODO: filter through query string
      businesses = ::Business.all || []

      render json: Surrealist.surrealize_collection(businesses, camelize: true)
    end

    # GET /businesses/:id
    def show
      business = ::Business.find_by(yelp_uid: params[:id])

      if business.present?
        render json: business.surrealize(camelize: true), status: :ok
      else
        render json: nil, status: :not_found
      end
    end

    private

    def business_params
      params.permit!
    end
  end
end
