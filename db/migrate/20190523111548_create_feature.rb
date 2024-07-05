class CreateFeature < ActiveRecord::Migration[5.2]
  def change
    create_table :features do |t|
      t.belongs_to :apartment
      t.boolean :air_conditioner, default: false
      t.boolean :alarm_system, default: false
      t.boolean :balcony, default: false
      t.boolean :built_in_wardrobe, default: false
      t.boolean :central_heating, default: false
      t.boolean :courtyard, default: false
      t.boolean :dishwasher, default: false
      t.boolean :ensuite, default: false
      t.boolean :floorboards, default: false
      t.boolean :garage, default: false
      t.boolean :home_gym, default: false
      t.boolean :outdoor_area, default: false
      t.boolean :outdoor_spa, default: false
      t.boolean :secure_parking, default: false
      t.boolean :shed, default: false
      t.boolean :swimming_pool, default: false
      t.boolean :tennis_court, default: false
      t.boolean :wine_cellar, default: false
      t.timestamps
    end
  end
end
