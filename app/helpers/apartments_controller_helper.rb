module ApartmentsControllerHelper
  include PostcodesHelper

  def save_search_query(title:,postcode_list:)
    @search_title = title
    SaveSearchResultsJob.perform(
      user: ( current_user if current_user.present? ),
      apartments_collection:nil,
      search_query: @params.to_unsafe_hash,
      search_title: @search_title,
    postcode_list: postcode_list )
  end

  def assign_title(saved_search_title)
    search_title = saved_search_title.present? ? saved_search_title : "result#{SecureRandom.hex(2)}"
  end

  # FIXME needed?
  # def prepare_search_criteria_from_params(asking_price_params,search_query)
  #   asking_prices = sort_asking_prices(asking_price_params)
  #   criteria = Apartment.includes([:user,:amenity,:feature,:descriptor]).find_matching_properties(asking_prices,search_query)
  # end

  def create_search_parameters
    parsed_params = search_params.to_unsafe_hash
    parsed_params["postcode"] = Apartment.remove_duplicate_postcodes(search_params[:postcode])
    draft_saved_search = session[:saved_search].present? ? session[:saved_search] : {query:parsed_params,title:saved_search_title_params[:saved_search_title]}
    if current_user.present? && draft_saved_search.present?
      current_user.searches.create!(draft_saved_search)
      session.delete "saved_search" if session[:saved_search].present?
    else
      session[:saved_search] = draft_saved_search
    end
  end

  # FIXME required?
  def default_image
    image_tag("default.png")
  end
end
