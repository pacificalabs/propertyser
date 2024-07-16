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
