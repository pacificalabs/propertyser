# == Schema Information
#
# Table name: floorplans
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apartment_id :bigint
#
# Indexes
#
#  index_floorplans_on_apartment_id  (apartment_id)
#
class Floorplan < ApplicationRecord
end
