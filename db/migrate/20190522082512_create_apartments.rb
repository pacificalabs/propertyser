class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.belongs_to :user
      t.belongs_to :location
      t.text :house_number
      t.text :street_address
      t.text :suburb
      t.text :state
      t.integer :postcode
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :parking_spaces
      t.integer :land_size
      t.integer :internal_space
      t.integer :asking_price
      t.float :latitude
      t.float :longitude
      t.text :description
      t.bigint :featured_photo_id
      t.boolean :strata, default: false
      t.boolean :approved, default: false
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end