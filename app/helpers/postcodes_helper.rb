module PostcodesHelper
  STATES = %w(NSW ACT SA QLD VIC TAS WA NT)

  # FIXME required? def self.geocode(postcode)
  #   begin
  #     logger.info "Geocoding #{postcode}..."
  #     Geocoder.configure(:timeout => 45)
  #     state = self.state(postcode)
  #     results = Geocoder.search(postcode+","+state)
  #     logger.info "Geocoded complete"
  #     long = results.first.data["lon"]
  #     lat = results.first.data["lat"]
  #   rescue StandardError => e
  #     logger.error "ERROR: #{e.inspect}"
  #   end
  #   return lat,long
  # end

  def check_state(postcode)
    code = postcode.to_i
    postcodes = {
      2000..2599 => "NSW",
      2619..2899 => "NSW",
      2921..2999 => "NSW",
      2600..2618 => "ACT",
      2900..2920 => "ACT",
      3000..3999 => "VIC",
      4000..4999 => "QLD",
      5000..5799 => "SA",
      6000..6797 => "WA",
      7000..7799 => "TAS",
      800..899 => "NT"
    }
    state = postcodes.select {|pc| pc === code}.values.first
  end

  def fetch_postcodes(locales_array)
    postcode_list = AusPostCode.where(id: locales_array).pluck(:postcode)
    #FIXME do the same for suburbs
  end

  def remove_duplicate_postcodes(postcode_list)
    postcode_list.scan(/[0-9]+/).uniq
  end

  def separate_into_postcodes(user_input)
    matches = []
    list = user_input.scan(/\w+/)
    postcodes = list.select {|w| w.to_i != 0 }
    postcodes.map { |postcode| matches << find_matching_records_nationwide(postcode) }
    return matches.flatten
  end

  def find_matching_records_in_state(postcode_string)
    state = check_state(postcode_string)
    eval "#{state.titlecase}Postcode.where(postcode:postcode_string)"
  end

  def find_matching_records_nationwide(postcode_string)
    AusPostCode.where(postcode:postcode_string)
  end
    # FIXME required? def self.parse_postcodes(search_params)
    #   code = search_params.scan(/[0-9]+/).uniq
    #   array = code.reject {|c| c.to_i/1000 > 10}
    # end

  end