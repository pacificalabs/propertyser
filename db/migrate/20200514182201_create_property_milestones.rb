class CreatePropertyMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :property_milestones do |t|
      t.belongs_to :apartment
      t.boolean :first_property_uploaded, default: false
      t.boolean :congratulated_on_first_property_uploaded, default: false      
      t.boolean :property_uploaded, default: false
      t.boolean :congratulated_on_property_uploaded, default: false
      t.string :type     
      t.timestamps
    end
  end
end
