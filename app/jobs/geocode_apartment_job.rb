class GeocodeApartmentJob
  def self.perform(apartment_id)
    Thread.new do
      begin
        a = Apartment.find(apartment_id)
        a.geocode
        unless a.geocoded?
          Rails.logger.debug("Unable to GeoCode: #{a.full_address}: #{a.id}")
        end
        a.save!
      rescue => e
        Rails.logger.error("Error geocoding apartment #{apartment_id}: #{e.message}")
      end
    end
  end
end
