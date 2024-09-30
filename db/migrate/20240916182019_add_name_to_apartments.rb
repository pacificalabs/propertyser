class AddNameToApartments < ActiveRecord::Migration[7.2]
  def change
    add_column :apartments, :name, :string
  end
end
