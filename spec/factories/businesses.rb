# == Schema Information
#
# Table name: businesses
#
#  id            :integer          not null, primary key
#  yelp_uid      :string           not null
#  name          :string
#  image_url     :string
#  url           :string
#  rating        :string
#  price         :string
#  phone         :string
#  display_phone :string
#  categories    :jsonb            is an Array
#  coordinates   :jsonb
#  location      :jsonb
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :business do
    yelp_uid "riveras-restaurant-springfield"
    name "Rivera's Restaurant"
    image_url "https://s3-media2.fl.yelpcdn.com/bphoto/H8wFZ9qfAimkGR1OSyUVCg/o.jpg"
    url "https://www.yelp.com/biz/riveras-restaurant-springfield"
    categories { [{ alias: "latin", title: "Latin American" }] }
    rating 4.0
    price "$$"
    phone "+17034515344"
    display_phone "(703) 451-5344"
    coordinates { { latitude: 38.7772099, longitude: -77.18436 } }
    location do
      { address1: "6552 Backlick Rd",
        address2: "",
        address3: "",
        city: "Springfield",
        zip_code: "22150",
        country: "US",
        state: "VA",
        display_address: ["6552 Backlick Rd", "Springfield, VA 22150"] }
    end
  end
end
