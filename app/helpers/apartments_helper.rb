module ApartmentsHelper
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

  def currency_to_number(currency)
    currency.to_s.gsub(/[$,]/,'').to_f
  end

  def select_tag_helper(apartment)
    @featured = PhotoDescription.find(apartment.featured_photo_id)
    @options_array = apartment.photos.pluck(:id).map.with_index {|id,index| ["PHOTO #{index+1}",id]}
    @actions_array = [["Choose a feature photo","set_featured_photo"],["Delete Photo","delete_photo"]]
  end

  def apartment_carousel_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=480&w=800&crop=entropy"
  end

  def apartment_results_page_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=400&w=612&crop=entropy"
  end

  def photo_edit_page_apartment_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=300&crop=entropy"
  end

  def ipad_photo_edit_page_apartment_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=400&w=650&crop=entropy"
  end

  def mobile_photo_edit_page_apartment_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=370&w=231&crop=entropy"
  end

  def photo_edit_page_apartment_image_ursl(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=250&w=250&crop=entropy"
  end

  def photo_update_page_apartment_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=300&crop=entropy"
  end

  def photo_edit_page_mobile_image_url(image)
    "https://propertyser.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=238&crop=entropy"
  end

  def floorplan_apartment_page_url(floorplan)
    "https://propertyser.imgix.net/#{floorplan.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=400&crop=entropy"
  end
end
