class CreatePhotoDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_descriptions do |t|
      t.text :description
      t.boolean :featured, default: false
      t.integer :photo_id
      t.belongs_to :apartment
      t.timestamps
    end
    add_index :photo_descriptions, :photo_id
  end
end
