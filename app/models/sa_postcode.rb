# == Schema Information
#
# Table name: sa_postcodes
#
#  id          :bigint           not null, primary key
#  lat         :float
#  locality    :string
#  long        :float
#  postcode    :integer
#  state       :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint
#
# Indexes
#
#  index_sa_postcodes_on_locality     (locality)
#  index_sa_postcodes_on_location_id  (location_id)
#  index_sa_postcodes_on_postcode     (postcode)
#
class SaPostcode < ApplicationRecord

  include Locatable
  include PgSearch::Model

  pg_search_scope :akin_to,
  against: :locality,
  using: :trigram

end
