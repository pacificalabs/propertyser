class CreateJoinTableApartmentUser < ActiveRecord::Migration[5.2]
  def change
    create_join_table :apartments, :users do |t|
      t.index [:apartment_id, :user_id]
      t.index [:user_id, :apartment_id]
    end
  end
end
