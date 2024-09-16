class PhotoDescriptionsController < ApplicationController
  def create
    p = PhotoDescription.create!(description_params)
    flash.notice = "Your description has been saved!"
    redirect_to photos_path(apartment_id: p.apartment.id)
  end

  def update
    @apartment = Apartment.friendly.find params[:apartment_id]
    if params[:featured]
      # @apartment.set_featured_photo(params[:id])
      flash[:notice] = "PHOTO SET AS FEATURE PHOTO"
    elsif params[:delete]
      @apartment.delete_photo_and_description(params["photo_description"]["blob_id"])
      flash[:notice] = "Photo Deleted!"
    elsif params[:commit] == "Update Description"
      @description = PhotoDescription.find_or_initialize_by(apartment_id: @apartment.id, blob_id: params["photo_description"]["blob_id"])
      @description.update!(description: params[:photo_description][:description])
      flash[:notice] = "Photo Description Updated!"
    end
    redirect_to photos_path(apartment_id: @apartment.id)
  end

  private
  def description_params
    params.require(:photo_description).permit(:description, :apartment_id, :blob_id)
  end
end
