# == Schema Information
#
# Table name: property_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PropertyType < ApplicationRecord
  has_many :apartments
end
