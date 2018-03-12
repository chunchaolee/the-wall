class AddIndexToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :fb_uid 
  end
end
