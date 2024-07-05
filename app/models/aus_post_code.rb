# == Schema Information
#
# Table name: aus_post_codes
#
#  id            :bigint           not null, primary key
#  dc            :string
#  lat           :float
#  locality      :string
#  locality_type :string
#  long          :float
#  postcode      :integer
#  state         :string
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  location_id   :bigint
#
# Indexes
#
#  index_aus_post_codes_on_locality     (locality)
#  index_aus_post_codes_on_location_id  (location_id)
#  index_aus_post_codes_on_postcode     (postcode)
#
class AusPostCode < ApplicationRecord

  include Locatable
    include PgSearch::Model

  pg_search_scope :akin_to,
  against: :locality,
  using: :trigram


  def self.seed_data
    take(100).pluck(:locality)
  end

  # TODO text search
  # def self.search(search)

  #   if search
  #     search_length = search.split.length
  #     find(:all, :conditions => [(['locality LIKE ?'] * search_length).join(' AND ')] + search.split.map { |locality| "%#{locality}%" })
  #   else
  #     find(:all)
  #   end

  # end

  def self.get_lat_long_for(locality_object_id)
    location = self.find(locality_object_id)
    return location.lat,location.long
  end

  # def self.get_lat_long(suburb_name)
  #   suburb_name = suburb_name[:location]
  #   list = []
  #   matches = AusPostCode.where(AusPostCode.arel_table[:locality].matches("%#{suburb_name}%"))
  #   matches.map {|match| list << [match.lat,match.long]}
  # end
end
