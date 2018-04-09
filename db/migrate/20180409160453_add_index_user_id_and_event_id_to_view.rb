class AddIndexUserIdAndEventIdToView < ActiveRecord::Migration[5.1]
  def change
    add_index :views, :user_id
    add_index :views, :event_id
  end
end
