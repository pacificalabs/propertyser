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
#  blob_id      :integer
#
# Indexes
#
#  index_photo_descriptions_on_apartment_id  (apartment_id)
#  index_photo_descriptions_on_blob_id       (blob_id) UNIQUE
#
class PhotoDescription < ApplicationRecord
  belongs_to :apartment
  belongs_to :photo_blob, class_name: 'ActiveStorage::Blob', foreign_key: :blob_id
end
