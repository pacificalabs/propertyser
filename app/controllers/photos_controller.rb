class PhotosController < ApplicationController

  def index
    @apartment = Apartment.find(params[:apartment_id])
    @floorplans = @apartment.floorplans if @apartment.floorplans.present? 
    @photos = @apartment.presort_photos if @apartment.photos.attached?
  end

  def create
    @apartment = Apartment.find photo_params[:apartment_id]
    @photo = @apartment.photos.attach(params[:photo][:photos])
    if @apartment.photos.attached?
      @apartment.photos.map { |pic| @apartment.photo_descriptions.create!(description: nil, photo_id: pic.id)  }
    end
    redirect_to photos_path(apartment_id:@apartment.id)
  rescue ArgumentError => e
    Rails.logger.error { "error: #{e}" }
    flash[:alert] = "There was an error, please try again."
    render "index"
  end

  def edit
    @apartment = Apartment.find(photo_edit_params[:apartment_id])
    @photo = @apartment.photos.find(photo_edit_params[:id])
  end

  def featured
    @apartment = Apartment.find(params[:apartment])
    @photos = @apartment.photos
    @featured_photo = @photos.find_by(@apartment.featured_photo_id)
    render "index"
  end

  def destroy
    @apartment = Apartment.find(photo_delete_params[:apartment])
    @apartment.delete_photo_and_description(params[:id])
    flash[:notice] = "DELETED PHOTO"
    redirect_to photos_path(apartment_id:@apartment.id)
  end

  def update
    @apartment = Apartment.find params[:attachment][:apartment_id]
      # define actions such as set feature or delete
      if params[:featured]
        @apartment.set_featured_photo(params[:id])
        flash[:notice] = "PHOTO SET AS FEATURE PHOTO"
      elsif params[:delete]
        @apartment.delete_photo_and_description(params[:id]) 
      elsif params[:update]
        @description = PhotoDescription.find_by_photo_id(params[:id])
        @description.update!(description:params[:attachment][:description])
      end
      redirect_to photos_path(apartment_id: @apartment.id)
    end

    private

    def photo_edit_params
      params.permit(:apartment_id,:id)
    end

    def photo_delete_params
      params.permit(:apartment,:id)
    end

    def photo_params
      params.require(:photo).permit(:photos,:apartment_id)
    end

  end