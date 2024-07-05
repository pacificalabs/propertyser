# == Schema Information
#
# Table name: comments
#
#  id           :bigint           not null, primary key
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apartment_id :bigint
#  comment_id   :bigint
#  user_id      :bigint
#  vote_id      :bigint
#
# Indexes
#
#  index_comments_on_apartment_id  (apartment_id)
#  index_comments_on_comment_id    (comment_id)
#  index_comments_on_user_id       (user_id)
#  index_comments_on_vote_id       (vote_id)
#
class Comment < ApplicationRecord
  belongs_to :apartment, optional: true
  belongs_to :user

  has_many :replies, class_name: "Comment"
  has_many :likes, class_name: "Vote"

  def like(user)
    likes.create!(user_id: user.id)    
  end

  def is_a_reply?
    comment_id.present? && apartment_id.blank?
  end

  def apartment
    is_a_reply? ? Comment.find(comment_id).apartment : Apartment.find(apartment_id)
  end

end