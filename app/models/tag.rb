# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tags_on_slug     (slug) UNIQUE
#  index_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
# app/models/tag.rb
class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :apartment_tags, dependent: :destroy
  has_many :apartments, through: :apartment_tags

  has_many :tag_relationships, foreign_key: :parent_tag_id, dependent: :destroy
  has_many :reverse_tag_relationships, foreign_key: :child_tag_id, class_name: 'TagRelationship', dependent: :destroy

  has_many :parent_tags, through: :reverse_tag_relationships, source: :parent_tag
  has_many :child_tags, through: :tag_relationships, source: :child_tag

  validates :name, presence: true
  validate :parent_tags_valid?

  before_validation :generate_slug, :format_name

  # Scope to find child tags
  scope :child_tags, -> {
    joins(:parent_tags).distinct
  }

  # Scope to find parent tags without children
  scope :orphaned_parents, -> {
    left_joins(:child_tags).where(child_tags: { id: nil }).distinct
  }

  def is_a_child_tag?
    parent_tags.exists?
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end

  def format_name
    self.name = name.titleize if name.present?
  end

  def parent_tags_valid?
    parent_tags.each do |parent_tag|
      if parent_tag.id == self.id
        errors.add(:parent_tags, "cannot include self")
      end
    end
  end
end
