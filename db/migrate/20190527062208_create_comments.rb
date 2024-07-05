class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :apartment
      t.belongs_to :user
      t.text :body
      t.references :comment, optional: true
      t.references :vote, optional: true
      t.timestamps
    end
  end
end
