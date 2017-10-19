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

class Business < ApplicationRecord
  has_many :business_favorites
end
