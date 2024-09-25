class CreatePhotoDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_descriptions do |t|
      t.text :description
      t.boolean :featured, default: false
      t.integer :blob_id
      t.belongs_to :apartment
      t.timestamps
    end
    add_index :photo_descriptions, :blob_id, unique: true
  end
end
