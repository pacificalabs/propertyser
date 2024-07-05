class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.belongs_to :comment
      t.belongs_to :user
      t.timestamps
    end
  end
end
