# == Schema Information
#
# Table name: features
#
#  id                :bigint           not null, primary key
#  air_conditioner   :boolean          default(FALSE)
#  alarm_system      :boolean          default(FALSE)
#  balcony           :boolean          default(FALSE)
#  built_in_wardrobe :boolean          default(FALSE)
#  central_heating   :boolean          default(FALSE)
#  courtyard         :boolean          default(FALSE)
#  dishwasher        :boolean          default(FALSE)
#  ensuite           :boolean          default(FALSE)
#  floorboards       :boolean          default(FALSE)
#  garage            :boolean          default(FALSE)
#  home_gym          :boolean          default(FALSE)
#  outdoor_area      :boolean          default(FALSE)
#  outdoor_spa       :boolean          default(FALSE)
#  secure_parking    :boolean          default(FALSE)
#  shed              :boolean          default(FALSE)
#  swimming_pool     :boolean          default(FALSE)
#  tennis_court      :boolean          default(FALSE)
#  wine_cellar       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  apartment_id      :bigint
#
# Indexes
#
#  index_features_on_apartment_id  (apartment_id)
#
class Feature < ApplicationRecord
  belongs_to :apartment, optional: true
end
