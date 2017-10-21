require "rails_helper"

describe "Yelp API", :vcr, type: :request, record: :new_episodes do
  describe "GET /yelp" do
    it "422 without required params" do
      get yelp_businesses_path

      expect(response).to have_http_status(422)
    end

    it "200 with valid location" do
      get yelp_businesses_path(location: "Washington, DC")

      expect(response).to have_http_status(200)
    end

    it "200 with valid coordinates" do
      get yelp_businesses_path(latitude: 38.8977, longitude: -77.0365)

      expect(response).to have_http_status(200)
    end
  end

  describe "GET /yelp/:id" do
    it "200 with valid yelp uid" do
      get yelp_business_path(id: "bul-washington")

      expect(response).to have_http_status(200)
    end
  end

  describe "GET /yelp/:id" do
    it "200 with valid yelp uid" do
      get yelp_business_path(id: "bul-washington")

      expect(response).to have_http_status(200)
    end

    it "422 with invalid yelp uid" do
      get yelp_business_path(id: "invalid-yelp-uid")

      expect(response).to have_http_status(422)
    end
  end

  describe "GET /yelp/:id/reviews" do
    it "200 with valid yelp uid" do
      get yelp_business_reviews_path(id: "bul-washington")

      expect(response).to have_http_status(200)
    end

    it "422 with invalid yelp uid" do
      get yelp_business_reviews_path(id: "invalid-yelp-uid")

      expect(response).to have_http_status(422)
    end
  end
end
