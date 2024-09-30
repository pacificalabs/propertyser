class PhotoDescriptionsController < ApplicationController
  def update_all
    @apartment = Apartment.friendly.find(params[:apartment_id])

    if params[:featured]
      set_as_featured_photo
    elsif params[:delete]
      delete_photo
    end
    update_photo_descriptions

    redirect_to photos_path(apartment_id: @apartment.id)
  end

  private

  def set_as_featured_photo
    @apartment.set_featured_photo(params[:featured])
    flash[:notice] = "Photo set as feature photo"
  end

  def delete_photo
    blob_id = params[:delete].keys.first
    @apartment.delete_photo_and_description(blob_id)
    flash[:notice] = "Photo deleted!"
  end

  def update_photo_descriptions
    params[:photos].each do |blob_id, photo_params|
      description = PhotoDescription.find_or_initialize_by(
        apartment_id: @apartment.id,
        blob_id: blob_id
      )
      description.update!(description: photo_params[:description])
    end
    flash[:notice] = "Photo descriptions updated!"
  end
end
