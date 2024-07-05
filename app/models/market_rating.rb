# == Schema Information
#
# Table name: market_ratings
#
#  id              :bigint           not null, primary key
#  suggested_price :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  apartment_id    :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_market_ratings_on_apartment_id  (apartment_id)
#  index_market_ratings_on_user_id       (user_id)
#
class MarketRating < ApplicationRecord
  belongs_to :apartment
end
