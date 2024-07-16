# == Schema Information
#
# Table name: apartment_tags
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apartment_id :bigint           not null
#  tag_id       :bigint           not null
#
# Indexes
#
#  index_apartment_tags_on_apartment_id             (apartment_id)
#  index_apartment_tags_on_apartment_id_and_tag_id  (apartment_id,tag_id) UNIQUE
#  index_apartment_tags_on_tag_id                   (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (apartment_id => apartments.id)
#  fk_rails_...  (tag_id => tags.id)
#
class ApartmentTag < ApplicationRecord
  belongs_to :apartment
  belongs_to :tag
  validates :apartment_id, uniqueness: { scope: :tag_id }
end
