require "rails_helper"

describe "v1/businesses API", :vcr, type: :request do
  describe "GET /v1/businesses" do
    it "200" do
      get v1_businesses_path

      expect(response).to have_http_status(200)
    end

    describe "per_page" do
      it "returns correct number of businesses" do
        (1..20).map { create(:business) }

        get v1_businesses_path(per_page: 3)

        expect(response.body).to eq(Surrealist.surrealize_collection(Business.limit(3), camelize: true))
        expect(response).to have_http_status(200)
      end
    end

    describe "rating_gt filter" do
      it "returns correct businesses" do
        1.times { create(:business, rating: 2) }
        2.times { create(:business, rating: 3) }
        3.times { create(:business, rating: 4) }
        4.times { create(:business, rating: 5) }

        get v1_businesses_path(q: { rating_gt: 3 })

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(7)
        expect(response).to have_http_status(200)
      end
    end

    describe "price_lt filter" do
      it "returns correct businesses" do
        3.times { create(:business, price: 1) }
        2.times { create(:business, price: 2) }
        1.times { create(:business, price: 3) }

        get v1_businesses_path(q: { price_lt: 3 })

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(5)
        expect(response).to have_http_status(200)
      end
    end

    describe "categories_cont filter" do
      it "returns correct businesses" do
        3.times { create(:business, categories: "korean,bbq") }
        5.times { create(:business, categories: "sushi") }
        1.times { create(:business, categories: "american,bbq") }

        get v1_businesses_path(q: { categories_cont: "bbq" })

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(4)
        expect(response).to have_http_status(200)
      end
    end

    describe "sort by distance" do
      it "returns correct businesses with valid coordinates" do
        leesburg_va = create(:business, :leesburg_va)
        white_house = create(:business)
        reston_va = create(:business, :reston_va)

        get v1_businesses_path(latitude: white_house.latitude, longitude: white_house.longitude)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response[0]["yelpUid"]).to eq(white_house.yelp_uid)
        expect(parsed_response[1]["yelpUid"]).to eq(reston_va.yelp_uid)
        expect(parsed_response[2]["yelpUid"]).to eq(leesburg_va.yelp_uid)
      end
    end

    describe "within" do
      it "returns correct businesses with valid coordinates" do
        white_house = create(:business)
        lincoln_memorial = create(:business, :lincoln_memorial)
        create(:business, :reston_va)
        create(:business, :leesburg_va)

        get v1_businesses_path(within: 10, latitude: white_house.latitude, longitude: white_house.longitude)

        parsed_response = JSON.parse(response.body)
        expect(parsed_response.size).to eq(2)
        expect(parsed_response[0]["yelpUid"]).to eq(white_house.yelp_uid)
        expect(parsed_response[1]["yelpUid"]).to eq(lincoln_memorial.yelp_uid)
      end
    end
  end

  describe "GET /v1/businesses/:id" do
    it "200 with valid yelp uid" do
      business = create(:business)

      get v1_business_path(business.yelp_uid)

      expect(response).to have_http_status(200)
    end

    it "404 with invalid yelp uid" do
      get v1_business_path("invalid-yelp-uid")

      expect(response).to have_http_status(404)
    end
  end

  describe "GET /v1/businesses/:id/reviews" do
    it "200 with valid yelp uid" do
      # yelp_uid here must be a one that exists in real life since we fetch reviews from yelp api.
      get v1_business_reviews_path("bul-washington")

      expect(response).to have_http_status(200)
    end
  end
end
