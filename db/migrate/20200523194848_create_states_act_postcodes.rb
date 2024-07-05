class CreateStatesActPostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :act_postcodes do |t|
     t.integer :postcode
     t.string :locality
     t.string :state
     t.float :lat
     t.float :long
     t.string :status
     t.belongs_to :location 
     t.timestamps
   end
   add_index :act_postcodes, :postcode
   add_index :act_postcodes, :locality
 end
end