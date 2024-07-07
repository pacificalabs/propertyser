module SuburbsHelper
  STATES = %w(NSW ACT SA QLD VIC TAS WA NT)

  def separate_into_suburbs(user_input)
    matches = []
    list = user_input.scan(/\w+/)
    suburbs = list.select {|w| w.to_i == 0 }
    suburbs.map { |suburb| matches << find_matching_suburbs_in_each_state(suburb) }
    return matches
  end

  def find_matching_suburbs_in_each_state(suburb_string)
    state_matches = []
    STATES.map do |state|
        eval "state_matches << #{state.titlecase}Postcode.akin_to('#{suburb_string}')"
      end
    return state_matches.flatten
  end

  def find_matching_suburbs_across_all_states(suburb_string)
    state_matches = AusPostCode.akin_to suburb_string
  end

  # FIXME required? def remove_duplicate_suburbs(suburb_list)
  #   case suburb_list.is_a?
  #   when String
  #     return false
  #   when Array
  #     return false
  #   else
  #     code = postcodes.to_s.scan(/[0-9]+/).uniq
  #     array = code.reject {|c| c.to_i/1000 > 10}
  #   end
  # end

  # FIXME required? def self.get_matches_for(suburb_name)
  #   suburb_name = suburb_name[:location]
  #   list = []
  #   binding.remote_pry
  #   # matches.map {|match| list << [match.lat,match.long]}
  # end
  
end