class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :artist_name
      t.string :album_name
      t.integer :rating
      t.integer :release_year
      t.string :comments
    end
  end
end
