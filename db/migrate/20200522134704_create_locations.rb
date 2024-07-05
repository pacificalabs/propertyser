class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :state
      t.string :alias_name
      t.float :lat
      t.float :long
      t.timestamps
    end
  end
end
