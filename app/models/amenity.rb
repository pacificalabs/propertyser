# == Schema Information
#
# Table name: amenities
#
#  id               :bigint           not null, primary key
#  beach            :boolean          default(FALSE)
#  bus_stop         :boolean          default(FALSE)
#  cafes            :boolean          default(FALSE)
#  childcare_centre :boolean          default(FALSE)
#  ferry_wharf      :boolean          default(FALSE)
#  golf_course      :boolean          default(FALSE)
#  grocery_store    :boolean          default(FALSE)
#  gym              :boolean          default(FALSE)
#  high_school      :boolean          default(FALSE)
#  hospital         :boolean          default(FALSE)
#  library          :boolean          default(FALSE)
#  light_rail       :boolean          default(FALSE)
#  medical_centre   :boolean          default(FALSE)
#  park             :boolean          default(FALSE)
#  playground       :boolean          default(FALSE)
#  primary_school   :boolean          default(FALSE)
#  restaurants      :boolean          default(FALSE)
#  shopping_centre  :boolean          default(FALSE)
#  swimming_pool    :boolean          default(FALSE)
#  train_station    :boolean          default(FALSE)
#  village_shops    :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  apartment_id     :bigint
#
# Indexes
#
#  index_amenities_on_apartment_id  (apartment_id)
#
class Amenity < ApplicationRecord
  belongs_to :apartment, optional: true
end
