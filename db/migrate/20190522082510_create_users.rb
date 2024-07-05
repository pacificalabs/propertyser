class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, required: true
      t.string :password_digest, required: true
      t.string :username
      t.string :firstname
      t.string :surname
      t.string :phone
      t.string :reset_password_token
      t.datetime :password_token_valid_until

      t.datetime :last_search_query_match
      t.boolean :is_admin, default: false
      t.boolean :accepted_terms_and_conditions, default: false

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

  end
end
