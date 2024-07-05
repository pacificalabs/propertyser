class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.belongs_to :user
      t.string :query
      t.string :title
      t.timestamps
    end
  end
end


# as a user
# I can do a search, save it with a title
# I can receive emails with any new properties which meet this criteria.

#search query has a title, compares properties added since the last search date

#search will have to be run as a job, batch job once a week to begin with
# then daily