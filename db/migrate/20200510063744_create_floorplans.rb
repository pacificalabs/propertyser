class CreateFloorplans < ActiveRecord::Migration[5.2]
  def change
    create_table :floorplans do |t|
      t.belongs_to :apartment
      t.timestamps
    end
  end
end
