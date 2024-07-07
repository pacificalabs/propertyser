class ApartmentsController < ApplicationController
  before_action :update_fullpath
  before_action :user_is_authorised?, except: [:search,:index,:search_location]
  before_action :load_icons, only: [:index,:new,:edit,:owner,:show]

  def search
    @apartment = Apartment.new
    # @searches = current_user.searches.where.not("title LIKE ?","result%").order('created_at DESC') if current_user.present?
  end

  def search_location
    @location_data = AusPostCode.where("lower(locality) LIKE lower(:data) OR lower(state) LIKE lower(:data) OR postcode::text LIKE :postcode", data: "%#{params[:data]}%", postcode: "#{params[:data]}%")
    render json: @location_data
  end

  def index
    @params = location_params.merge search_params if search_params.present?
    @search_title = helpers.assign_title(saved_search_title_params[:saved_search_title])
    suburb_list = helpers.find_matching_suburbs_across_all_states(location_params[:locale])
    if location_params[:locale]
      @postcode_list = []
      location_params[:locale].each do |locale|
        @postcode_list << helpers.separate_into_postcodes(locale)
      end
    end
    @options = (((suburb_list + @postcode_list).flatten).uniq)
    helpers.save_search_query(title: @search_title, postcode_list: @options)
    load_search_query
    @apartments = Search.find_apartments( @search_query, user: current_user )
  rescue StandardError => e
    Rails.logger.error { "error: #{e}" }
    flash[:alert] = "There was an error, please try again."
    flash[:alert] = "Please select atleast one location." if e.to_s.include?("no implicit conversion of nil into Array")
    redirect_to search_path
  end

  def new
    @apartment = Apartment.new
    @feature = Feature.new
    @descriptor = Descriptor.new
    @amenity = Amenity.new
    @apartment.feature = @feature
    @apartment.descriptor = @descriptor
    @apartment.amenity = @amenity
  end

  def create
    begin
      @apartment = Apartment.new(apartment_params)
      @apartment.bedrooms = params[:bedrooms]
      @apartment.bathrooms = params[:bathrooms]
      @apartment.strata = params[:strata]
      @apartment.parking_spaces = params[:parking_spaces]
      @apartment.asking_price = helpers.currency_to_number(apartment_params[:asking_price])
      f = Feature.new(feature_params[:feature])
      @apartment.feature = f
      d = Descriptor.new(descriptor_params[:descriptor])
      @apartment.descriptor = d
      a = Amenity.new(amenity_params[:amenity])
      @apartment.amenity = a
      @apartment.user = current_user
      @apartment.save
      @apartment.valid? && flash[:notice] = "Your property has been saved to draft. Please describe your photo#{"s" if params[:apartment][:photos].size > 1} and add any floorplan if available."
      if params[:apartment][:photos]
        @apartment.photos.attach(params[:apartment][:photos])
        if @apartment.photos.attached?
          @apartment.photos.each do |pic|
            @apartment.photo_descriptions.create!(description: nil, photo_id: pic.id)
          end
        end
      end
    rescue Exception => e
      redirect_to new_apartment_path, alert: "There was an error. #{e.inspect}. Please try again"
      logger.error { "#{action_name} ERROR: #{e.inspect}" }
    end
    redirect_to photos_path(apartment_id: @apartment.id)
  end

  def edit
    @apartment = Apartment.includes([:feature,:descriptor,:amenity]).find(params[:id])
    @feature = @apartment.feature.present? ? @apartment.feature : @apartment.build_feature
    @descriptor = @apartment.descriptor.present? ? @apartment.descriptor : @apartment.build_descriptor
    @amenity = @apartment.amenity.present? ? @apartment.amenity : @apartment.build_amenity
  end

  def location
  end

  def features
  end

  def update
    begin
      @apartment = Apartment.find(params[:id])
      @apartment.update! apartment_params.except("asking_price").merge!asking_price: helpers.currency_to_number(apartment_params[:asking_price])
      @apartment.floorplans.attach(params[:apartment][:floorplans]) if params[:apartment][:floorplans].present?
      @apartment&.feature&.destroy!
      @apartment.create_feature!(feature_params[:feature])
      @apartment&.descriptor&.destroy!
      @apartment.create_descriptor!(descriptor_params[:descriptor])
      @apartment&.amenity&.destroy!
      @apartment.create_amenity!(amenity_params[:amenity])
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => e
      logger.error { "#{action_name} Error #{e.inspect}" }
      flash[:alert] = "Error< #{e.inspect.split(":\ ").last}"
      redirect_to edit_apartment_path(apartment_id: @apartment.id) and return false
    end
    redirect_to photos_path(apartment_id: @apartment.id)
  end

  def destroy
    @apartment = Apartment.find(params[:id])
    @apartment.destroy!
    redirect_to myproperties_path
    flash[:alert] = "PROPERTY WAS DELETED!"
  end


  def size
  end

  def price
  end

  def description
  end

  def comment
    # FIXME this doesnt make sense
    begin
    rescue StandardError => e
      logger.error { "Error: #{action_name} #{e.inspect}" }
      @apartment = Apartment.find_by_id(comment_params[:id])
      @comment = @apartment.comments.new(body: comment_params[:comment], user_id: comment_params[:user_id])
      @comment.save!
    end
    redirect_to @apartment
  end

  def photos
  end

  def owner
    @apartments = current_user.apartments.order(created_at: :desc).with_attached_photos
  end

  def show
    begin
      @apartment = Apartment.includes(:user,:amenity,:feature,{comments:[:user,:replies]}).with_attached_photos.find(params[:id])
      @self_rating = @apartment.market_ratings.find_by_user_id(current_user.id)
      @features = @apartment&.feature&.attributes&.select {|k,f| f == true }
      @features = @features.keys if @features.present?
      @descriptors = @apartment&.descriptor&.attributes&.select {|k,f| f == true }
      @descriptors = @descriptors.keys if @descriptors.present?
      @amenities = @apartment&.amenity&.attributes&.select {|k,f| f == true }
      @amenities = @amenities.keys if @amenities.present?
      @featured_photo = @apartment.photos.find(@apartment.featured_photo_id) if @apartment.featured_photo_id.present?
      @floorplans = @apartment.floorplans
      @search_title = params[:title]
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.debug { "#{e}" }
      flash[:alert] = "We were unable to display that property."
      redirect_to apartments_path
    end
  end

  def submit
    helpers.congratulate_owner
    redirect_to apartment_path(id: apartment_id_params[:property_id])
  end

  def return_to_search_results
    begin
      search = current_user.searches.find_by_title(params[:title])
      query = eval(search.query)
      postcodes = query["postcode"]
      @postcodes = postcodes.to_s.gsub(/[()-+."\[\]]/,'')
      @apartments = search.results
      @search_title = search.title
      render "index"
    rescue Exception => e
      Rails.logger.debug { "#{e}" }
      redirect_to apartments_path
    end
  end

  private

  def load_search_query
    locales_data = @options.pluck(:state, :id)
    @search_query = run_saved_search_params.present? ? Search.find(run_saved_search_params[:id]) : Search.find_by_title(saved_search_title_params[:saved_search_title])
    if locales_data.present?
      @user_selected_locations = Location.get_location_list( locales_data )
      @search_query.save_user_selected_locations(@user_selected_locations)
    else
      @user_selected_locations = @search_query.selections
    end
  rescue Exception => e
    Rails.logger.error { e.inspect }
  end
  # TODO split this out into 2 separate functions

  def store_search_parameters
    helpers.create_search_parameters
  end

  def return_to_search_page
    redirect_to search_path and return unless search_params.present?
  end

  def get_postcode_list_from_query
    helpers.fetch_postcodes(locales_params)
    # remove_duplicate_postcodes
  end

  def apartment_id_params
    params.permit(:property_id)
  end

  def saved_search_title_params
    params.require(:apartment).permit(:saved_search_title)
  end

  def run_saved_search_params
    params.permit(:run_saved_search,:id)
  end

  def apartment_params
    params.require(:apartment).permit(:house_number, :strata, :bedrooms, :bathrooms,:parking_spaces,:postcode,:street_address, :suburb, :description, :land_size, :internal_space, :asking_price, :photos, :floorplans)
  end

  def feature_params
    params.require(:apartment).permit({
                                        feature: [{air_conditioner:[]},
                                                  {alarm_system:[]},
                                                  {balcony:[]},
                                                  {built_in_wardrobe:[]},
                                                  {central_heating:[]},
                                                  {courtyard:[]},
                                                  {dishwasher:[]},
                                                  {ensuite:[]},
                                                  {floorboards:[]},
                                                  {garage:[]},
                                                  {home_gym:[]},
                                                  {outdoor_area:[]},
                                                  {outdoor_spa:[]},
                                                  {secure_parking:[]},
                                                  {shed:[]},
                                                  {swimming_pool:[]},
                                                  {tennis_court:[]},
                                                  {wine_cellar:[]}]})
  end

  def photo_params
    params.require(:apartment).permit(photos:[])
  end

  def amenity_params
    params.require(:apartment).permit(
      amenity: [{beach:[]},
                {bus_stop:[]},
                {cafes:[]},
                {childcare_centre:[]},
                {ferry_wharf:[]},
                {golf_course:[]},
                {grocery_store:[]},
                {gym:[]},
                {high_school:[]},
                {hospital:[]},
                {library:[]},
                {light_rail:[]},
                {medical_centre:[]},
                {park:[]},
                {playground:[]},
                {primary_school:[]},
                {restaurants:[]},
                {shopping_centre:[]},
                {swimming_pool:[]},
                {train_station:[]},
                {village_shops:[]}])
  end

  def descriptor_params
    params.require(:apartment).permit(
      descriptor: [{airy:[]},
                   {bright:[]},
                   {cosy:[]},
                   {district_view:[]},
                   {elegant:[]},
                   {luxurious:[]},
                   {original:[]},
                   {renovated:[]},
                   {unrenovated:[]},
                   {spacious:[]},
                   {water_view:[]}])
  end

  def asking_price_params
    params.permit(:min_pricing,:max_pricing)
  end

  def search_params
    params.permit(:locale,:min_pricing,:max_pricing,:strata,:min_bedrooms,:max_bedrooms,:min_bathrooms,:max_bathrooms,:min_parking,:max_parking)
  end

  def postcode_params
    params.require(:apartment).permit(:postcode)
  end

  def suburb_params
    params.require(:apartment).permit(:suburb)
  end

  def locales_params
    params.require(:locales)
  end

  def location_params
    params.require(:apartment).permit(:min_bedrooms,:max_bedrooms,:min_bathrooms,:max_bathrooms,:min_parking,:max_parking, locale: [])
  end

  def descriptor_params
    params.require(:apartment).permit(
      descriptor: [{airy:[]},
                   {brand_new:[]},
                   {bright:[]},
                   {cosy:[]},
                   {district_view:[]},
                   {elegant:[]},
                   {luxurious:[]},
                   {original:[]},
                   {renovated:[]},
                   {unrenovated:[]},
                   {spacious:[]},
                   {water_view:[]}])
  end

  def photo_description_params
    params.require(:photo_description)
  end

end
