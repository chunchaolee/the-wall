class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :artist_name
      t.string :title
      t.date :date
      t.string :time
      t.string :img
      t.string :video
      t.string :url
      t.text :detail
      t.text :city
      t.text :stage
      t.integer :views_count
      t.integer :intersets_count

      t.timestamps
    end
  end
end
