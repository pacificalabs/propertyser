class CreateStatesNtPostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :nt_postcodes do |t|
     t.integer :postcode
     t.string :locality
     t.string :state
     t.float :lat
     t.float :long
     t.string :status
     t.belongs_to :location 
     t.timestamps
   end
   add_index :nt_postcodes, :postcode
   add_index :nt_postcodes, :locality
 end
end
