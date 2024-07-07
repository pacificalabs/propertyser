module ApartmentsHelper

  def currency_to_number(currency)
    currency.to_s.gsub(/[$,]/,'').to_f
  end

  def select_tag_helper(apartment)
    @featured = PhotoDescription.find(apartment.featured_photo_id)
    @options_array = apartment.photos.pluck(:id).map.with_index {|id,index| ["PHOTO #{index+1}",id]}
    @actions_array = [["Choose a feature photo","set_featured_photo"],["Delete Photo","delete_photo"]]    
  end

  def apartment_carousel_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=480&w=800&crop=entropy"
  end

  def apartment_results_page_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=400&w=612&crop=entropy"
  end

  def photo_edit_page_apartment_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=300&crop=entropy"
  end

  def ipad_photo_edit_page_apartment_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=400&w=650&crop=entropy"    
  end

  def mobile_photo_edit_page_apartment_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=370&w=231&crop=entropy"
  end

  def photo_edit_page_apartment_image_ursl(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=250&w=250&crop=entropy"
  end

  def photo_update_page_apartment_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=300&crop=entropy"
  end

  def photo_edit_page_mobile_image_url(image)
    "https://h1.imgix.net/#{image.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=238&crop=entropy"
  end

  def floorplan_apartment_page_url(floorplan)
    "https://h1.imgix.net/#{floorplan.key}?usm=20&auto=format%2Cenhance&fit=crop&h=300&w=400&crop=entropy"
  end
end
