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

class Business < ApplicationRecord
  include Surrealist

  acts_as_mappable default_units: :miles,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  has_many :business_likes

  json_schema do
    {
      yelp_uid: String,
      name: String,
      image_url: String,
      url: String,
      rating: BigDecimal,
      price: Integer,
      phone: String,
      display_phone: String,
      categories: String,
      latitude: BigDecimal,
      longitude: BigDecimal,
      city: String,
      state: String,
      country: String,
      address1: String,
      address2: String,
      address3: String,
      zip_code: String,
      display_address: Array
    }

    # https://github.com/geokit/geokit-rails#new-scopes-to-use
    # - within and beyond:    find records within or beyond a certain distance from the origin point
    # - in_range:             find records within a certain distance range from the origin point
    # - in_bounds:            find records within a rectangle on the map
    # - closest and farthest: find the closest or farthest record from the origin point
    # - by_distance:          find records ordered by distance from the origin point
  end
end
