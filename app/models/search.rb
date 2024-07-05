# == Schema Information
#
# Table name: searches
#
#  id         :bigint           not null, primary key
#  query      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_searches_on_user_id  (user_id)
#
class Search < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :results, class_name: "Apartment"
  has_many :selections, class_name: "Location", dependent: :destroy
  has_and_belongs_to_many :locations

  def selected_location_names
    selections.pluck(:name).to_s.gsub(/[()-+."\[\]]/,'').gsub(",",", ")
  end

  def recall_property_specifications
    query = eval(self.query)
  end

  def save_user_selected_locations(locations_collection)
    selections << Location.find(locations_collection.pluck(:location_id))
  end

  def self.find_apartments(search_instance_model, user: nil )
    @search_instance_model = search_instance_model
    self.load_search_components(@search_instance_model)
    @apartments = @location_list.each_with_object([]) do | location, apartments |
      nearby_matches = @criteria.joins([:user,:amenity,:feature,:descriptor]).preload([:user,:amenity,:feature,:descriptor])
      apartments += nearby_matches
      return apartments
    end.flatten.uniq
    @apartments = user.present? ? @apartments.not_owned_by(user) : @apartments
    @search_instance_model.results << @apartments
  end

  def rehydrate_search_criteria_from_query_object
    specs = recall_property_specifications
    asking_prices = self.class.sort_asking_prices({min_asking_price: specs["min_pricing"],max_asking_price: specs["max_pricing"]})
    criteria = Apartment.find_matching_properties(asking_prices, specs)
  end

  def self.sort_asking_prices(asking_price_params)
    min_asking =  asking_price_params[:min_asking_price].to_i*0.9
    max_asking =  asking_price_params[:max_asking_price].to_i.*1.1
    if min_asking > max_asking
      max_temp = min_asking
      min_temp = max_asking
      min_asking = min_temp
      max_asking = max_temp
    end
    return { min_asking_price: min_asking, max_asking_price: max_asking }
  end

  def self.load_search_components(search_instance_model)
    @radius = 5
    @location_list = search_instance_model.selections
    @criteria = search_instance_model.rehydrate_search_criteria_from_query_object
    puts "ll:#{@location_list.length}"
    puts "criteria: #{@criteria.length}, #{@criteria.pluck :id}"
    missing_component = [@radius, @location_list, @criteria].select {|object| object.blank? }
    if missing_component.present?
      Rails.logger.error { "ERROR missing_component in load_search_components: #{missing_component}" } 
      return Apartment.none
    end
  end

end
