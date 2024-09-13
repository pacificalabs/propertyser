class PhotosController < ApplicationController

  def index
    @apartment = Apartment.find(params[:apartment_id])
    @floorplans = @apartment.floorplans if @apartment.floorplans.present?
    @photos = @apartment.presort_photos if @apartment.photos.attached?
  rescue StandardError => e
    Rails.logger.error { "error: #{e}" }
    flash[:alert] = "There was an error, please try again."
    redirect_to apartments_path
  end

  def create
    @apartment = Apartment.find(photo_params[:apartment_id])

    # Attach new photos to the apartment
    new_photos = params[:photo][:photos]
    initial_size = @apartment.photos.size
    @photos = @apartment.photos.attach(new_photos)

    # Only add photo descriptions for newly added photos
    if @apartment.photos.size > initial_size
      @photos.each do |photo|
        @apartment.photo_descriptions.find_or_create_by!(description: nil, blob_id: photo.id)
      end
    end

    redirect_to photos_path(apartment_id: @apartment.id)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Apartment not found."
    redirect_to apartments_path
  rescue ArgumentError => e
    Rails.logger.error "Error: #{e.message}"
    flash[:alert] = "There was an error attaching photos, please try again."
    render :index
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
    @apartment = Apartment.find params[:photo_description][:apartment_id]
    # define actions such as set feature or delete
    if params[:featured]
      # @apartment.set_featured_photo(params[:id])
      flash[:notice] = "PHOTO SET AS FEATURE PHOTO"
    elsif params[:delete]
      @apartment.delete_photo_and_description(params[:id])
      flash[:notice] = "Photo Deleted!"
    elsif params[:update]
      @description = PhotoDescription.find_or_initialize_by(apartment_id: @apartment.id, blob_id: params[:id])
      @description.update!(description: params[:photo_description][:description])
      flash[:notice] = "Photo Description Updated!"
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
