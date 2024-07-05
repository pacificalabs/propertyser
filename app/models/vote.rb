# == Schema Information
#
# Table name: votes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_votes_on_comment_id  (comment_id)
#  index_votes_on_user_id     (user_id)
#
class Vote < ApplicationRecord
  belongs_to :comment, optional: true
end
