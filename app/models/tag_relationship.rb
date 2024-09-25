# == Schema Information
#
# Table name: tag_relationships
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  child_tag_id  :bigint           not null
#  parent_tag_id :bigint           not null
#
# Indexes
#
#  index_tag_relationships_on_child_tag_id                    (child_tag_id)
#  index_tag_relationships_on_parent_tag_id                   (parent_tag_id)
#  index_tag_relationships_on_parent_tag_id_and_child_tag_id  (parent_tag_id,child_tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (child_tag_id => tags.id)
#  fk_rails_...  (parent_tag_id => tags.id)
#
# app/models/tag_relationship.rb
class TagRelationship < ApplicationRecord
  belongs_to :parent_tag, class_name: 'Tag'
  belongs_to :child_tag, class_name: 'Tag'

  validate :prevent_circular_reference

  private

  def prevent_circular_reference
    if parent_tag_id == child_tag_id
      errors.add(:base, 'Parent tag and child tag cannot be the same')
    end
  end
end
