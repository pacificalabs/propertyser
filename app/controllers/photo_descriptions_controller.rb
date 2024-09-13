class PhotoDescriptionsController < ApplicationController
  def create
    p = PhotoDescription.create!(description_params)
    flash.notice = "Your description has been saved!"
    redirect_to photos_path(apartment_id: p.apartment.id)
  end

  def update
    p = PhotoDescription.find(params[:id])
    p.update(description_params)
    flash.notice = "Your description has been updated!"
    redirect_to photos_path(apartment_id: p.apartment.id)
  end

  private
  def description_params
    params.require(:photo_description).permit(:description, :apartment_id, :blob_id)
  end
end
