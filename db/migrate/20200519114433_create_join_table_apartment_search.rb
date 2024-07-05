class CreateJoinTableApartmentSearch < ActiveRecord::Migration[5.2]
  def change
    create_join_table :apartments, :searches do |t|
      t.index [:apartment_id, :search_id]
      t.index [:search_id, :apartment_id]
    end
  end
end
