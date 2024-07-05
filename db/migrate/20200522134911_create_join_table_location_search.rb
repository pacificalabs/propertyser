class CreateJoinTableLocationSearch < ActiveRecord::Migration[5.2]
  create_join_table :locations, :searches do |t|
    t.index [:location_id, :search_id]
    t.index [:search_id, :location_id]
  end
end