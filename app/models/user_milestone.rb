# == Schema Information
#
# Table name: user_milestones
#
#  id                      :bigint           not null, primary key
#  email_address_confirmed :boolean          default(FALSE)
#  reset_password          :boolean          default(FALSE)
#  sent_welcome_letter     :boolean          default(FALSE)
#  type                    :string
#  updated__username       :boolean          default(FALSE)
#  updated_email           :boolean          default(FALSE)
#  updated_phone_number    :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint
#
# Indexes
#
#  index_user_milestones_on_user_id  (user_id)
#
class UserMilestone < ApplicationRecord
  belongs_to :user
end
