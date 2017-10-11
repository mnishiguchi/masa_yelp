module Yelp
  class Request
    attr_accessor :response

    def initialize(type, params)
      request(type, params)
    end

    def valid?
      @response[:error].nil?
    end

    private

    def request(type, params)
      @response = Yelp::Client.instance.request(type, params)
    end
  end
end
