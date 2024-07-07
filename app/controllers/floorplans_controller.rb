class FloorplansController < ApplicationController
  def destroy
    @apartment = Apartment.find(floorplans_params[:apartment_id])
    @apartment.floorplans.find(floorplans_params[:id]).purge_later
    flash[:notice] = "Floorplan Deleted"
    redirect_to photos_path(apartment_id:@apartment.id)
  end

  private

  def floorplans_params
    params.permit(:apartment_id,:id)
  end
end
