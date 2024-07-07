namespace :db do
  desc "create user"
  task create_aus_post_code: :environment do
    include PostcodesHelper
    puts "creating AUSPostcode"
    puts Benchmark.measure {
      file = "australian_postcodes.json"
      list = JSON.parse(File.read(Rails.root.join(file)))
      @aus_postcodes = []
      list.each do |item|
        pc= item.to_h.slice("postcode","locality","state","lat","long","status")
        next unless check_state(pc["postcode"]).present?
        postcode_instance = AusPostCode.new(pc)
        @aus_postcodes << postcode_instance
      end
      import_states
    }
  end

  def import_states
    begin
      AusPostCode.import! @aus_postcodes
    rescue StandardError => e
      puts "ERROR !"
      puts e
    end  
  end

end
