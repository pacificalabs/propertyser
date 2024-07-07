class IndexController < ApplicationController
  skip_before_action :user_is_authorised?
  layout :resolve_layout

  def index
    @content = ["Control Your Process", "Do Your Research", "Increase Your Options", "Free To Buy", "Anonymous To List", "Sell With Power"]
  end

  def buy_sell
  end

  def about    
  end
  
  def contact
    @apartment = Apartment.find apartment_params[:id] if apartment_params.present?
  end
  
  def faq
  end
  
  def terms_and_conditions
    if current_user.present? && current_user.accepted_terms? == false
      @user = current_user 
    end
  end
  
  def step_by_step
  end
  
  def policy
  end

  def device_warning
  end

  private

  def resolve_layout
    case action_name
    when "device_warning"
      "blank"
    else
      "application"
    end
  end

  def apartment_params
    params.permit(:id)
  end
 
end