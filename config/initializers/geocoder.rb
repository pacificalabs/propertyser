Geocoder.configure(
  lookup: :nominatim,
  units: :km,
  cache: Redis.new,
  http_headers: { "User-Agent" => "Propertyser/1.0 (contact: lee@toonstudio.com.au)" }
)
