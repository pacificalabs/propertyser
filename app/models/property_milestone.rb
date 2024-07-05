# == Schema Information
#
# Table name: property_milestones
#
#  id                                       :bigint           not null, primary key
#  congratulated_on_first_property_uploaded :boolean          default(FALSE)
#  congratulated_on_property_uploaded       :boolean          default(FALSE)
#  first_property_uploaded                  :boolean          default(FALSE)
#  property_uploaded                        :boolean          default(FALSE)
#  type                                     :string
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  apartment_id                             :bigint
#
# Indexes
#
#  index_property_milestones_on_apartment_id  (apartment_id)
#
class PropertyMilestone < ApplicationRecord
  belongs_to :apartment
end
