# == Schema Information
#
# Table name: business_favorites
#
#  id          :integer          not null, primary key
#  business_id :integer          not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BusinessFavorite < ApplicationRecord
  belongs_to :business
  belongs_to :user
end
