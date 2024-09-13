class GeocodeApartmentJob
  def self.perform(apartment_id)
    Thread.new do
      begin
        a = Apartment.find(apartment_id)

        # Store current latitude and longitude for comparison
        old_latitude = a.latitude
        old_longitude = a.longitude

        # Perform geocoding
        a.geocode
        # Check if the geocoded values have changed
        if a.latitude != old_latitude || a.longitude != old_longitude
          if a.geocoded?
            a.update_columns(
              latitude: a.latitude,
              longitude: a.longitude
            )
            Rails.logger.info("GeoCoded: #{a.full_address}: #{a.id}")
          else
            Rails.logger.debug("Unable to GeoCode: #{a.full_address}: #{a.id}")
          end
        end
      rescue => e
        Rails.logger.error("Error geocoding apartment #{apartment_id}: #{e.message}")
      end
    end
  end
end
