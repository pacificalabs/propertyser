class AddDisplayOptionToApartments < ActiveRecord::Migration[7.2]
  def change
    add_column :apartments, :display_option, :string, default: 'both'
  end
end
