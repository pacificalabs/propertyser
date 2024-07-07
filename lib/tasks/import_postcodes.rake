namespace :db do
  desc "Import postcodes.json file into the database"
  task :import_postcodes, [:path] => :environment do |_t, args|
    puts Benchmark.measure {
      AusPostCode.transaction do
        file = args.path
        list = JSON.parse(File.read(file))
        postcodes = []
        list.each_with_index do |item,index|
          pc= item.to_h.slice("postcode","locality","state","lat","long","status")
          puts "#{index}: #{pc}"
          postcodes << AusPostCode.new(pc)
        end
        AusPostCode.import! postcodes
      end
    }
  end
end