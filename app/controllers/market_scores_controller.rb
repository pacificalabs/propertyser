class MarketScoresController < ApplicationController

  def create
    @apartment = Apartment.find_by_id(params[:apartment_id])
    @market_rating = @apartment.market_ratings.new(suggested_price: market_params[:suggested_price], user_id: current_user.id)
    @market_rating.save!
    redirect_to @apartment
  end

  private  
  def market_params
    params.require(:market_rating).permit(:suggested_price,:apartment_id)
  end

end
