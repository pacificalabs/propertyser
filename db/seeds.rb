# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
include PostcodesHelper

def seed_address
  csv_data = CSV.parse(File.read('lib/csv/seed_addresses.csv'), :headers => true).map{|a| a.to_hash}
  address_data = []
  csv_data.each do |data|
    data["postcode"] = data["postcode"].gsub(",","").to_i
    address_data << data
  end
  return address_data
end

def destroy_models
  puts "destroy_models"
  User.destroy_all
  Apartment.destroy_all
  Search.destroy_all
  Location.destroy_all
  delete_state_models
end

def attach_pics(apartment)
  pics = ["image2melbournecityaparment.jpg","image1sydneycityapartment.jpg"]
  pics.each_with_index do |pik, shindex|
    apartment.photos.attach(io: File.open(Rails.root.join("./app/assets/images/#{pik}")),filename: "#{pik}",content_type:'image/png')
    puts "attached! #{apartment.photos.pluck :blob_id}" if apartment.photos.attached?
    apartment.photos.each do |pic|
      description = apartment.photo_descriptions.create!(description: "pic #{shindex+1}", blob_id: pic.blob_id, featured: false)
      # p.featured && self.update!(featured_photo_id:p.photo_id)
    end
  end
end

def create_users(users)
  @users = users.each do |new_user|
    u = User.create! new_user
    u.milestones.create! sent_welcome_letter: true, email_address_confirmed: true
  end
end

def create_state_arrays
  @states.map { |state| eval "@#{state.downcase}_postcodes = []" }
end

def delete_state_models
  AusPostCode.delete_all
end

@user_list = [
  {:firstname => "Tarun", :email => "tarun@pacificasearch.com", "password":"gdaymate", "username":"tarunm", is_admin:true, accepted_terms_and_conditions: true},
  {:firstname => "Tarun", :email => "test@test.com", "password":"gdaymate", "username":"tyrone", is_admin:false, accepted_terms_and_conditions: false},
  {:firstname => "Lee", :email => "lee@toonstudio.com.au", "password":"gdaymate", "username":"leesheppard", is_admin:true, accepted_terms_and_conditions: true}
]

small_numbers = (1..10).to_a
numbers = (1..100).to_a
pricing = [600000,800000,1000000,1500000,2000000]
comments = [
  "i like this but can the room be bigger?",
  "Love the views!!!!",
  "Looks like you've renovated it recently?",
  "Where can I learn more about this place?"
]
addresses = seed_address

@states = ["NSW","ACT","SA","QLD","VIC","TAS","WA","NT"]

puts "#{Apartment.count} apartments present."
puts "#{User.count} users present."

time1 = Benchmark.measure do
  destroy_models
end
puts "Time to destroy models"
puts time1


time2 = Benchmark.measure {
  puts "creating users"
  create_users(@user_list)

  t1 = Tag.create(name: 'Luxury', user_id: User.first.id)
  t2 = Tag.create(name: 'Pet-friendly', user_id: User.first.id)

  puts "creating properties!"

  5.times do |cycle|
    User.all.each_with_index do |u,i|
      puts u.email
      a = u.apartments.new (addresses[cycle])
      puts a.full_address
      a.approved = true
      a.bedrooms = small_numbers.sample
      a.bathrooms = small_numbers.sample
      a.strata = [true,false].sample
      a.parking_spaces = small_numbers.sample
      a.asking_price = pricing.sample

      puts "$#{a.asking_price}"
      a.save!
      puts a.full_address
      attach_pics a
      ([t1,t2].sample).apartments << a
      comments.map { |comment|  a.comments.create!( user: User.all.sample , body:comment ) }
    end
  end
}

puts "Seeded #{Apartment.count} apartments."
puts time2

puts "#{@users.count} users present."
puts "#{AusPostCode.count} postcodes present"
