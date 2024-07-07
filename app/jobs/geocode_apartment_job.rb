class GeocodeApartmentJob < ApplicationJob
  queue_as :default

  def perform(apartment_id)
    a = Apartment.find(apartment_id)
    a.geocode
    logger.debug { "Unable to GeoCode:#{a.full_address}: #{a.id}" }
    a.save!
  end  
end