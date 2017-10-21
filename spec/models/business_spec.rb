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

require "rails_helper"

describe Business, type: :model do
  it "has valid factory" do
    expect(create(:business)).to be_valid
  end
end
