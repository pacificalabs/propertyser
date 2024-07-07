STATES = ["NSW","ACT","SA","QLD","VIC","TAS","WA","NT"]

def delete_state_models
  AusPostCode.delete_all
  STATES.map { |state| eval "#{state.titlecase}Postcode.delete_all" }
end

def destroy_models
  puts "destroy_models"
  sh('rails d model User')
  sh('rails d model Apartment')
  sh('rails d model Search')
  sh('rails d model Location')
  User.destroy_all
  Apartment.destroy_all
  Search.destroy_all
  Location.destroy_all
  delete_state_models
end

namespace :db do
  desc "Erases database"
  task :erase_data do |_t, args|
    puts Benchmark.measure {
      puts "erase_data"
      destroy_models
    }
  end
end