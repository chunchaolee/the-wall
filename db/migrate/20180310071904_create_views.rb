class CreateViews < ActiveRecord::Migration[5.1]
  def change
    create_table :views do |t|
      t.integer :user_id
      t.integer :event_id
      t.datetime :view_time

      t.timestamps
    end
  end
end
