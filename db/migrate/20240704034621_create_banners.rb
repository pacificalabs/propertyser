class CreateBanners < ActiveRecord::Migration[7.1]
  def change
    create_table :banners do |t|
      t.references :user, null: false, foreign_key: true
      t.string :image
      t.string :link

      t.timestamps
    end
  end
end
