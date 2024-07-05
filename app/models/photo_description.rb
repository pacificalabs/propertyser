# == Schema Information
#
# Table name: photo_descriptions
#
#  id           :bigint           not null, primary key
#  description  :text
#  featured     :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apartment_id :bigint
#  photo_id     :integer
#
# Indexes
#
#  index_photo_descriptions_on_apartment_id  (apartment_id)
#  index_photo_descriptions_on_photo_id      (photo_id)
#
class PhotoDescription < ApplicationRecord
  belongs_to :apartment
  # after_update :congratulate_owner,
  # :if => proc {|obj| obj.apartment.photo_descriptions.count == 1 && obj.description.present?}

# FIXME changes vs previous changes as trigger for congratulations
  # def congratulate_owner
  #   puts     
  # end

end
