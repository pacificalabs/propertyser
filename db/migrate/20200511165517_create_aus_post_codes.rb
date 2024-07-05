class CreateAusPostCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :aus_post_codes do |t|   
     t.integer :postcode
     t.string :locality
     t.string :state
     t.float :lat
     t.float :long
     t.string :dc
     t.string :locality_type
     t.string :status
     t.belongs_to :location 
     t.timestamps
   end
   add_index :aus_post_codes, :postcode
   add_index :aus_post_codes, :locality
 end
end
