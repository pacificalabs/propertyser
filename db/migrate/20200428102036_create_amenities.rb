class CreateAmenities < ActiveRecord::Migration[5.2]
  def change
    create_table :amenities do |t|
      t.belongs_to :apartment
      t.boolean :childcare_centre, default: false
      t.boolean :primary_school, default: false
      t.boolean :high_school, default: false
      t.boolean :bus_stop, default: false
      t.boolean :train_station, default: false
      t.boolean :ferry_wharf, default: false
      t.boolean :park, default: false
      t.boolean :playground, default: false
      t.boolean :golf_course, default: false
      t.boolean :beach, default: false
      t.boolean :gym, default: false
      t.boolean :library, default: false
      t.boolean :light_rail, default: false
      t.boolean :shopping_centre, default: false
      t.boolean :swimming_pool, default: false
      t.boolean :village_shops, default: false
      t.boolean :restaurants, default: false
      t.boolean :cafes, default: false
      t.boolean :grocery_store, default: false
      t.boolean :hospital, default: false
      t.boolean :medical_centre, default: false
      t.timestamps
    end
  end
end