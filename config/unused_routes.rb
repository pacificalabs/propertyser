# prints out unused routes in cli
# to use call 'rails runner config/unused_routes.rb' from the command line

Rails.application.eager_load!
unused_routes = {}

# Iterating over all non-empty routes from RouteSet
Rails.application.routes.routes.map(&:requirements).reject(&:empty?).each do |route|
  name = route[:controller].camelcase
  next if name.start_with?("Rails")

  controller = "#{name}Controller"

  if Object.const_defined?(controller) && !controller.constantize.new.respond_to?(route[:action])
    # Get route for which associated action is not present and add it in final results
    unless Dir.glob(Rails.root.join("app", "views", name.downcase, "#{route[:action]}.*")).any?
      unused_routes[controller] = [] if unused_routes[controller].nil?
      unused_routes[controller] << route[:action]
    end
  end
end

puts "unused routes:"
ap unused_routes 
# {"HomeController"=>["edit", "update", "update", "destroy"]}