class PhotoDescriptionsController < ApplicationController
  def update
    p = PhotoDescription.find(params[:id])
    p.update(description_params)
    redirect_to photos_path(apartment_id: p.apartment.id)
  end

  private
  def description_params
    params.require(:photo_description).permit(:description)
  end
  def apartment_params
    params.permit(:apartment_id,:id)
  end
end
