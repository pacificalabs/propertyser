# == Schema Information
#
# Table name: apartments
#
#  id                :bigint           not null, primary key
#  approved          :boolean          default(FALSE)
#  archived          :boolean          default(FALSE)
#  asking_price      :integer
#  bathrooms         :integer
#  bedrooms          :integer
#  description       :text
#  house_number      :text
#  internal_space    :integer
#  land_size         :integer
#  latitude          :float
#  longitude         :float
#  parking_spaces    :integer
#  postcode          :integer
#  state             :text
#  strata            :boolean          default(FALSE)
#  street_address    :text
#  suburb            :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  featured_photo_id :bigint
#  location_id       :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_apartments_on_latitude_and_longitude  (latitude,longitude)
#  index_apartments_on_location_id             (location_id)
#  index_apartments_on_user_id                 (user_id)
#
class Apartment < ApplicationRecord

  before_destroy :purge_from_storage
  after_create :create_associations

  # TODO change this to get lat long from db
  after_create :run_geocode_job
  geocoded_by :full_address

  belongs_to :user
  belongs_to :location, optional: true
  has_and_belongs_to_many :searches
  has_and_belongs_to_many :fans, class_name: "User"

  has_one :descriptor, dependent: :destroy
  has_one :feature, dependent: :destroy
  has_one :amenity, dependent: :destroy
  has_many_attached :photos, dependent: :destroy 
  has_many_attached :floorplans, dependent: :destroy
  
  has_many :comments, dependent: :destroy
  has_many :market_ratings, dependent: :destroy 
  has_many :photo_descriptions, dependent: :destroy
  has_many :property_milestones, dependent: :destroy
  accepts_nested_attributes_for :feature, :descriptor, :amenity, :comments, :photo_descriptions, :property_milestones

  scope :not_owned_by, ->(user) { where.not(user_id: user.id) }

  def create_associations
    Feature.create! apartment: self
    Descriptor.create! apartment: self
    Amenity.create! apartment: self
  end

  def owner
    user
  end

  def owner_is(user_model)
    user == user_model
  end

  def image_url
    super || default_image
  end

  def address_line_1
    "#{street_address}".titlecase
  end

  def address_line_2
    "#{suburb} #{postcode}".titlecase
  end

  def full_address
    "#{house_number} #{street_address&.titlecase} #{suburb&.titlecase} #{postcode}"
  end

  def full_address_line_1
    "#{house_number} #{street_address}".titlecase
  end

  def approve
    self.update!("approved": true)
  end

  def revoke_approval
    self.update!("approved": false)    
  end

  def self.approved?
    find_by(:approved => true)
  end

  def self.archived
    where(:archived => true)
  end

  def self.un_archived
    where(:archived => false)
  end

  def archive
    self.update!("archived":true)
  end

  def unarchive
    self.update!("archived":false)
  end

  def milestones
    property_milestones
  end

  def update_postcode
    begin
    result = Geocoder.search([self.latitude,self.longitude])
    self.update!(postcode: result.first.postal_code)      
    rescue Exception => e
      Rails.logger.debug { "#{e}" }
      return nil
    end
  end

  def self.find_matching_properties(asking_prices,params)
    where("asking_price BETWEEN :min_pricing AND :max_pricing", {min_pricing:asking_prices[:min_asking_price], max_pricing:asking_prices[:max_asking_price]})
    .where("bedrooms BETWEEN :min_bedrooms AND :max_bedrooms", {min_bedrooms: params["min_bedrooms"].to_i, max_bedrooms: params["max_bedrooms"].to_i})
    .where("bathrooms BETWEEN :min_bathrooms AND :max_bathrooms", {min_bathrooms: params["min_bathrooms"].to_i, max_bathrooms: params["max_bathrooms"].to_i } )
    .where("parking_spaces BETWEEN :min_parking_spaces AND :max_parking_spaces", {min_parking_spaces: params["min_parking"].to_i, max_parking_spaces: params["max_parking"].to_i})
    .where("approved":true)
    .where("archived":false)
  end

  def average_suggested_price
    market_ratings.average(:suggested_price).round if market_ratings.present?
  end

  def median_suggested_price
    array = market_ratings.pluck(:suggested_price)
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def delete_photo_and_description(photo_id)
    self.photo_descriptions.find_by_photo_id(photo_id).destroy!
    self.photos.find(photo_id).purge_later
    self.update(featured_photo_id:nil)
  end

  def presort_photos
    begin
      featured = photo_descriptions.find_by_featured(true) && photo_descriptions.find_by_featured(true).photo_id 
      photo_list = self.photos.order('created_at DESC').pluck(:id)
      photo_list.delete(featured)
      photo_list.unshift(featured)
      photos = Array.new
      photo_list.map { |pic| photos.push(self.photos.find(pic))   }
    rescue Exception => e
      logger.error { "#{e}" }
      return self.photos
    end
    return photos 
  end

  def set_featured_photo(id)
    photo_descriptions.find_by(featured:true) && photo_descriptions.find_by(featured:true).update(featured:false)
    photo_descriptions.find_by_photo_id(id).update!(featured:true)
    update!(featured_photo_id:id)
  end

  def purge_from_storage
    photos.each do |pic|
      pic.purge_later
      logger.info { "Photo with ID: #{pic.id} PURGED!" }
    end
  end

  def congratulate_owner_on_first_drafted_property
    return false if self.property_milestone.minimum_completed == true 
    self.property_milestone.update! minimum_completed: true
    # FIXME property_milestone.congratulated_on_first_property.freeze
  end

  def self.crow_flies(collection_of_two_points)
    two_points = collection_of_two_points
    raise StandardError.new "2 apartments are not present" if two_points.length != 2
    locations = two_points.map {|a| "#{a.latitude},#{a.longitude}" }
    Geocoder::Calculations.distance_between(locations[0],locations[1])
  end

  def run_geocode_job
    GeocodeApartmentJob.perform_later(self.id)
  end

end
