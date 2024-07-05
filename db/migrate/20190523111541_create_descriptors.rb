class CreateDescriptors < ActiveRecord::Migration[5.2]
  def change
    create_table :descriptors do |t|
      t.belongs_to :apartment
      t.boolean :airy, default: false
      t.boolean :bright, default: false
      t.boolean :brand_new, default: false
      t.boolean :cosy, default: false
      t.boolean :district_view, default: false
      t.boolean :elegant, default: false
      t.boolean :luxurious, default: false
      t.boolean :original, default: false
      t.boolean :renovated, default: false
      t.boolean :unrenovated, default: false
      t.boolean :spacious, default: false
      t.boolean :water_view, default: false
      t.timestamps
    end
  end
end