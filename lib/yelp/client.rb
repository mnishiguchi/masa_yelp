require "singleton"

module Yelp
  class Client
    include Singleton
    attr_reader :configuration

    API_HOST = "https://api.yelp.com".freeze
    TOKEN_PATH = "/oauth2/token".freeze
    BUSINESSES_PATH = "/v3/businesses/search".freeze
    BUSINESS_PATH = ->(id) { "/v3/businesses/#{id}" }
    BUSINESS_REVIEWS_PATH = ->(id) { "/v3/businesses/#{id}/reviews" }

    # Lists request types supported by this class.
    def self.request_types
      instance_methods.select { |m| m.to_s.start_with? "request_" }.map { |m| m.to_s.gsub("request_", "") }
    end

    def initialize
      ensure_env_variables
      @configuration = { client_id: ENV["YELP_API_KEY"],
                         client_secret: ENV["YELP_API_SECRET"],
                         grant_type: "client_credentials".freeze }
      @conn = connect(API_HOST)
    end

    def request(type, params)
      types = Yelp::Client.request_types
      return build_error_hash("Request type must be one of #{types}.") unless types.include?(type)
      return build_error_hash("Please provide supported params.") if params.blank?

      send("request_#{type}", params).deep_symbolize_keys
    end

    # https://www.yelp.com/developers/documentation/v3/business_search
    def request_businesses(params)
      http_get_with_bearer_token(BUSINESSES_PATH, params)
    end

    # https://www.yelp.com/developers/documentation/v3/business
    def request_business(params)
      id = params.fetch(:id)
      http_get_with_bearer_token(BUSINESS_PATH[id])
    end

    # https://www.yelp.com/developers/documentation/v3/business_reviews
    def request_business_reviews(params)
      id = params.fetch(:id)
      http_get_with_bearer_token(BUSINESS_REVIEWS_PATH[id])
    end

    private

    def connect(url)
      raise "Already connected" if connected?

      Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def connected?
      @conn.present?
    end

    def request_authentication
      req = @configuration.slice(:client_id, :client_secret, :grant_type)
      response = @conn.post(TOKEN_PATH, req)
      JSON.parse(response.body)
    end

    def bearer_token
      @bearer_token ||= begin
        auth = request_authentication.values_at("token_type", "access_token")
        auth.join(" ")
      end
    end

    def http_get_with_bearer_token(path, params = {})
      response = @conn.get(path, params) do |req|
        req.headers["Authorization"] = bearer_token
      end
      JSON.parse(response.body)
    end

    def ensure_env_variables
      %w[YELP_API_KEY YELP_API_SECRET].each do |var|
        raise ArgumentError, "Set up your #{var} environment var." if ENV[var].blank?
      end
    end

    def build_error_hash(description)
      { error: { code: "MASA_YELP", description: description } }
    end
  end
end
