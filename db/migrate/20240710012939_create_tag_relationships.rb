class CreateTagRelationships < ActiveRecord::Migration[7.1]
  def change
    create_table :tag_relationships do |t|
      t.references :parent_tag, null: false, foreign_key: { to_table: :tags }
      t.references :child_tag, null: false, foreign_key: { to_table: :tags }

      t.timestamps
    end

    add_index :tag_relationships, [:parent_tag_id, :child_tag_id], unique: true
  end
end
