class CreateUserMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :user_milestones do |t|
      t.belongs_to :user
      t.boolean :sent_welcome_letter, default: false
      t.boolean :email_address_confirmed, default: false
      t.boolean :updated_phone_number, default: false
      t.boolean :updated_email, default: false
      t.boolean :updated__username, default: false      
      t.boolean :reset_password, default: false
      t.string :type     
      t.timestamps
    end
  end
end
