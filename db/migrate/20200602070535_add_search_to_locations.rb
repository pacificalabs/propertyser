class AddSearchToLocations < ActiveRecord::Migration[5.2]
  def change
    add_reference :locations, :search, foreign_key: true
  end
end
