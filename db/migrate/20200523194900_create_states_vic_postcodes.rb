class CreateStatesVicPostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :vic_postcodes do |t|
     t.integer :postcode
     t.string :locality
     t.string :state
     t.float :lat
     t.float :long
     t.string :status
     t.belongs_to :location 
     t.timestamps
   end
   add_index :vic_postcodes, :postcode
   add_index :vic_postcodes, :locality
 end
end
