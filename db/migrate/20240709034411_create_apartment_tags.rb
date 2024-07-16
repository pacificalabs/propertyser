class CreateApartmentTags < ActiveRecord::Migration[7.1]
  def change
    create_table :apartment_tags do |t|
      t.references :apartment, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :apartment_tags, [:apartment_id, :tag_id], unique: true
  end
end
