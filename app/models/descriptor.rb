# == Schema Information
#
# Table name: descriptors
#
#  id            :bigint           not null, primary key
#  airy          :boolean          default(FALSE)
#  brand_new     :boolean          default(FALSE)
#  bright        :boolean          default(FALSE)
#  cosy          :boolean          default(FALSE)
#  district_view :boolean          default(FALSE)
#  elegant       :boolean          default(FALSE)
#  luxurious     :boolean          default(FALSE)
#  original      :boolean          default(FALSE)
#  renovated     :boolean          default(FALSE)
#  spacious      :boolean          default(FALSE)
#  unrenovated   :boolean          default(FALSE)
#  water_view    :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  apartment_id  :bigint
#
# Indexes
#
#  index_descriptors_on_apartment_id  (apartment_id)
#
class Descriptor < ApplicationRecord
  belongs_to :apartment, optional: true
end
