# == Schema Information
#
# Table name: users
#
#  id                            :bigint           not null, primary key
#  accepted_terms_and_conditions :boolean          default(FALSE)
#  email                         :string
#  firstname                     :string
#  is_admin                      :boolean          default(FALSE)
#  last_search_query_match       :datetime
#  password_digest               :string
#  password_token_valid_until    :datetime
#  phone                         :string
#  reset_password_token          :string
#  surname                       :string
#  username                      :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar, dependent: :destroy
  has_many :apartments, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :searches, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_milestones, dependent: :destroy

  has_and_belongs_to_many :favourites, class_name: "Apartment"
  accepts_nested_attributes_for :user_milestones

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: [:create]

  after_create_commit :send_email_address_confirmation

  def is_admin?
    is_admin == true
  end

  def set_password_token(valid_for:)
    return false unless valid_for.class == ActiveSupport::Duration
    self.update(reset_password_token: SecureRandom.alphanumeric(20))
    self.update(password_token_valid_until: Time.now + valid_for)
  end

  def total_properties
    apartments.load.size
  end

  def accepted_terms?
    accepted_terms_and_conditions == true
  end

  def unlike(comment)
    comment.likes.find_by_user_id(self.id)&.delete
  end

  def like(comment)
    comment.likes.create!(user_id: self.id)
  end

  def milestones
    user_milestones
  end

  def already_liked_comment?(comment)
    comment.likes.find_by_user_id(self.id).present?
  end

  def self.summary
    ap pluck :email,:id,:username
  end

  private

  def send_email_address_confirmation
    User::RequestEmailAddressConfirmationJob.perform(user_id: self.id)
  end

end
