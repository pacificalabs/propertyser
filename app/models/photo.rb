# == Schema Information
#
# Table name: photos
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  apartment_id :bigint
#
# Indexes
#
#  index_photos_on_apartment_id  (apartment_id)
#
class Photo < ApplicationRecord
  before_destroy :purge_from_storage 


  def image_url
    super || default_image
  end
  has_one_attached :file
  # validates_attachment :file, content_type: ["image/png", "image/jpeg", "image/jpg"]
  belongs_to :apartment
  # TODO validates_attachment method not recognised
  # FIXME validate :check_file_type

  private

  def purge_from_storage
    each do |pic|
      pic.purge_later
      logger.info { "Photo MODEL with ID: #{pic.id} PURGED!" }
    end
  end


  def check_file_type
    if file.attached? && !file.content_type.in?(%w(image/png, image/jpeg, image/jpg))
      file.purge_later # delete the uploaded file
      errors.add(:file, 'Must be a .jpg, .jpeg or a .png file')
    end
  end

end
