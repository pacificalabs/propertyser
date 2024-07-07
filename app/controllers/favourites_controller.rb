class FavouritesController < ApplicationController
  def create
    apartment = Apartment.find favourite_params[:id]
    current_user.favourites << apartment
    redirect_back(fallback_location: users_path, alert: "Added #{apartment.full_address} to your favourites list")
  end

  def destroy
    apartment = Apartment.find favourite_params[:id]
    current_user.favourites.destroy apartment
    redirect_back(fallback_location: users_path, alert: "Removed #{apartment.full_address} from your favourites list")
  end

  private
  def favourite_params
    params.permit(:id)
  end
end
