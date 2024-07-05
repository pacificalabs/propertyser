# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  alias_name :string
#  lat        :float
#  long       :float
#  name       :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  search_id  :bigint
#
# Indexes
#
#  index_locations_on_search_id  (search_id)
#
# Foreign Keys
#
#  fk_rails_...  (search_id => searches.id)
#
class Location < ApplicationRecord
  has_and_belongs_to_many :searches
  has_many :apartments
  has_many :aus_post_codes
  has_many :nsw_postcodes
  has_many :qld_postcodes
  has_many :act_postcodes
  has_many :vic_postcodes
  has_many :tas_postcodes
  has_many :nt_postcodes
  has_many :sa_postcodes
  has_many :wa_postcodes

  def update_geographic_centre(state_string)
    list = aus_post_codes.pluck :lat,:long
    centre = Geocoder::Calculations.geographic_center(list)
    update! lat: centre[0], long: centre[1]
    Rails.logger.info { "updated_geographic_centre(#{state_string},#{id})" if changed? } 
  end

  def self.get_location_list(search_model)
    search_model = [search_model] if search_model.is_a? String
    @locations = search_model.each_with_object([]) do |location, locations|
      pcode = AusPostCode.find(location[1])
      locations << { location_id: pcode.location_id, id: pcode.id, lat: pcode.lat, long: pcode.long }
    end
    return @locations
  end
  # FIXME create scope in location which bypasses the need to run eval on this as there is only ever going to be one state
  # TODO required?
  # ApplicationController.helpers.save_search_query( title: search_query.title, postcode_list: @postcodes )
end
