class CreateMarketRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :market_ratings do |t|
      t.integer :suggested_price
      t.belongs_to :apartment
      t.belongs_to :user
      t.timestamps
    end
  end
end
