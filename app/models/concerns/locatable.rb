module Locatable
  extend ActiveSupport::Concern

  included do
    after_update :update_geographic_centre_on_parent_location
    belongs_to :location, optional: true
  end
  
  def update_geographic_centre_on_parent_location
    location.update_geographic_centre(state)
  end
  
end