namespace :db do
  desc "Seed database, load postcode data"
  task :prep_database do |_t, args|
    puts Benchmark.measure {
      puts "seeding"
      Rake::Task["db:seed"].invoke
      puts "import_postcodes"
      Rake::Task["db:import_postcodes"].invoke('australian_postcodes.json')
    }
  end
end