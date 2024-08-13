class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :device_is_mobile?
  helper_method :device_is_ipad?
  helper_method :device_is_tablet?
  helper_method :device_is_surface?
  before_action :user_is_authorised?
  before_action :read_user_agent
  before_action :set_tags

  def set_tags
    @tags = current_user.tags.includes(:child_tags, :parent_tags).all if current_user.present?
  end

  def read_user_agent
    client = DeviceDetector.new(request.user_agent)
    puts "User Agent: #{request.user_agent}"
    puts "Browser: name: #{browser.name} meta: #{browser.meta} device name:#{browser.device.name}"
    puts "Device Detector: client.name: #{client.name} client: device_name: #{client.device_name}" if client.known?
    puts "viewPort: #{cookies[:viewPort].present? ? cookies[:viewPort] : 'cookies[:viewPort] absent'} & Cookies: #{cookies.present?}"
    puts "location_info: #{request.location.data}"
    puts device_is_tablet?
  end

  def user_is_authorised?
    confirm_login
    confirm_admin
  end

  def current_user
    # FIXME if User.find session user_id?
    begin
      if session[:user_id].present?
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
        # FIXME scenarios for which this should be cleared
        # clear_notices_and_alerts
      end
    rescue ActiveRecord::RecordNotFound => e
      logger.error { "#{e.inspect}" }
      flash[:notice] = "We cannot find your details. Please Sign in or Register to continue"
      reset_session
      return false
    end
  end

  def update_fullpath
    session[:lastpath] = session[:fullpath] if session[:fullpath].present?
    session[:fullpath] = request.fullpath
  end

  def destroy_fullpath
    session.delete "fullpath"
    session.delete "lastpath"
    session.delete "saved_search"
  end

  def clear_notices_and_alerts
    flash.delete "notice"
    flash.delete "alert"
  end

  def notify_admin_team(mailer,data = {})
    User.where(is_admin: true).find_each do |admin_user|
      AdminMailer.with(recipient:admin_user,data:data).send(mailer).deliver_later
    end
  end

  def device_is_surface?
    request.user_agent.include?("Windows NT")
  end

  def device_is_ipad?
    request.user_agent.include?("iPad")
  end

  def device_is_mobile?
    a = request.user_agent.include?("Mobile") || device_is_tablet? || device_is_ipad?
  end

  def device_is_tablet?
    if cookies && cookies[:viewPort].present?
      if cookies[:viewPort].include?("width")
        viewport_dimensions = JSON.parse cookies[:viewPort]
        vw = viewport_dimensions["width"]
        vh = viewport_dimensions["height"]
      else
        vp = cookies[:viewPort].split(',').map(&:to_i)
        vh = vp[0]
        vw = vp[1]
      end
      return (vw > 799 && vw < 1100) || device_is_ipad?
    end
  end

  def confirm_admin
    if controller_name == "admin" && !current_user.is_admin?
      flash[:alert] = "You are not authorised to view this page."
      redirect_back(fallback_location: root_path) and return false
    end
  end

  def confirm_login
    unless current_user.present?
      # FIXME required?
      # reset_session
      redirect_to mobile_login_path, alert: "Please sign in or register to continue"
    end
    return true
  end

  protected

  def previous_page
    session[:fullpath].present? ? session[:fullpath] : search_path
  end

  def global_request_logging
    http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP.*")}
    http_request_headers = request.headers.select{|header_name, header_value| http_request_header_keys.index(header_name)}
    logger.info { "Received #{request.method.inspect}  \n\e to #{request.url.inspect} \n\efrom #{request.remote_ip.inspect}.\n\e Processing with PARAMS: #{params.inspect}" }
    begin
      yield
    ensure
      logger.info { "Responding with #{response.status.inspect}" }
    end
  end

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def load_icons
    @amenity_icons = amenity_icons
    @feature_icons = feature_icons
    @descriptor_icons = descriptor_icons
  end

  def feature_icons
    {:air_conditioner => get_aws_url("white_icons/icons8-air-conditioner-50.png"),
     :alarm_system => get_aws_url("dark_icons/icons8-alarm-50.png"),
     :balcony => get_aws_url("white_icons/icons8-balcony-50.png"),
     :built_in_wardrobe => get_aws_url("white_icons/icons8-wardrobe-50.png"),
     :central_heating => get_aws_url("white_icons/icons8-radiator-50.png"),
     :courtyard => get_aws_url("white_icons/icons8-potted-plant-50.png"),
     :dishwasher => get_aws_url("white_icons/icons8-dishwasher-50.png"),
     :ensuite => get_aws_url("white_icons/icons8-bath-50.png"),
     :floorboards => get_aws_url("white_icons/icons8-wooden-floor-50.png"),
     :garage => get_aws_url("white_icons/icons8-garage-50.png"),
     :home_gym => get_aws_url("dark_icons/icons8-dumbbell-50.png"),
     :outdoor_area => get_aws_url("dark_icons/icons8-oak-tree-50.png"),
     :outdoor_spa => get_aws_url("dark_icons/icons8-spa-50.png"),
     :secure_parking => get_aws_url("white_icons/icons8-garage-50.png"),
     :shed => get_aws_url("white_icons/icons8-dog-house-50.png"),
     :swimming_pool => get_aws_url("dark_icons/icons8-lap-pool-50.png"),
     :tennis_court => get_aws_url("dark_icons/icons8-tennis-racquet-50.png"),
     :wine_cellar => get_aws_url("dark_icons/icons8-wine-bottle-50.png")}
  end

  def amenity_icons
    {:beach => get_aws_url("dark_icons/icons8-beach-50.png"),
     :bus_stop => get_aws_url("dark_icons/icons8-bus-50.png"),
     :cafes => get_aws_url("dark_icons/icons8-cafe-50.png"),
     :childcare_centre => get_aws_url("dark_icons/icons8-child-safe-zone-50.png"),
     :ferry_wharf => get_aws_url("dark_icons/icons8-water-wheel-50.png"),
     :golf_course => get_aws_url("dark_icons/icons8-sphere-50.png"),
     :gym => get_aws_url("dark_icons/icons8-deadlift-50.png"),
     :grocery_store => get_aws_url("dark_icons/icons8-shopping-basket-50.png"),
     :high_school => get_aws_url("dark_icons/icons8-graduate-50.png"),
     :hospital => get_aws_url("dark_icons/icons8-ambulance-50.png"),
     :library => get_aws_url("dark_icons/icons8-book-shelf-50.png"),
     :light_rail => get_aws_url("white_icons/icons8-subway-50.png"),
     :medical_centre => get_aws_url("dark_icons/icons8-stethoscope-50.png"),
     :park => get_aws_url("dark_icons/icons8-leaf-50.png"),
     :playground => get_aws_url("dark_icons/icons8-soccer-50.png"),
     :primary_school => get_aws_url("dark_icons/icons8-class-50.png"),
     :restaurants => get_aws_url("dark_icons/icons8-restaurant-50.png"),
     :shopping_centre => get_aws_url("dark_icons/icons8-shopping-cart-50.png"),
     :swimming_pool => get_aws_url("white_icons/icons8-outdoor-swimming-pool-50.png"),
     :train_station => get_aws_url("dark_icons/icons8-train-50.png"),
     :village_shops => get_aws_url("dark_icons/icons8-shopping-bag-50.png")}
  end

  def descriptor_icons
    {:airy => get_aws_url("dark_icons/icons8-fan-50.png"),
     :brand_new => get_aws_url("dark_icons/icons8-new-50.png"),
     :bright => get_aws_url("white_icons/icons8-sun-50.png"),
     :cosy => get_aws_url("dark_icons/icons8-tea-50.png"),
     :district_view => get_aws_url("dark_icons/icons8-forest-50.png"),
     :elegant => get_aws_url("dark_icons/icons8-crown-50.png"),
     :luxurious => get_aws_url("dark_icons/icons8-diamond-50.png"),
     :original => get_aws_url("dark_icons/icons8-warehouse-50.png"),
     :renovated => get_aws_url("dark_icons/icons8-hammer-50.png"),
     :unrenovated => get_aws_url("dark_icons/icons8-drill-50.png"),
     :spacious => get_aws_url("dark_icons/icons8-fit-to-width-50.png"),
     :water_view => get_aws_url("dark_icons/icons8-water-transportation-50.png")}
  end

end
