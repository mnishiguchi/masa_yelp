# == Schema Information
#
# Table name: businesses
#
#  id              :integer          not null, primary key
#  yelp_uid        :string           not null
#  name            :string
#  image_url       :string
#  url             :string
#  categories      :string
#  rating          :decimal(, )
#  price           :integer
#  latitude        :decimal(, )
#  longitude       :decimal(, )
#  address1        :string
#  address2        :string
#  address3        :string
#  city            :string
#  state           :string
#  country         :string
#  zip_code        :string
#  display_address :string           default([]), is an Array
#  phone           :string
#  display_phone   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :business do
    yelp_uid { Faker::Crypto.md5 }
    name { Faker::Company.name }
    image_url "https://s3-media3.fl.yelpcdn.com/bphoto/AcYacjW7k-tg-_UGvvCRmg/o.jpg"
    url "https://www.yelp.com/biz/bul-washington"
    categories "korean,bars"
    rating 4.0
    price 2
    phone "+12027333921"
    display_phone "(202) 733-3921"
    latitude 38.8977
    longitude(-77.0365)
    address1 "1600 Pennsylvania Ave NW"
    address2 ""
    address3 ""
    city "Washington, DC"
    zip_code "20500"
    country "US"
    state "DC"
    display_address do
      [
        "1600 Pennsylvania Ave NW",
        "Washington, DC 20500"
      ]
    end

    trait :lincoln_memorial do
      latitude 38.8893
      longitude(-77.0502)
      city "Washington, DC"
      state "DC"
      zip_code "20037"
    end

    trait :reston_va do
      latitude 38.9586
      longitude(-77.3570)
      city "Reston"
      state "VA"
      zip_code "20190"
    end

    trait :leesburg_va do
      latitude 39.1157
      longitude(-77.5636)
      city "Leesburg"
      state"VA"
      zip_code "20176"
    end
  end
end
