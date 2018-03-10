class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :email
      t.text :content

      t.timestamps
    end
  end
end
