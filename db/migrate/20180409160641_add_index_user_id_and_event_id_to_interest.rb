class AddIndexUserIdAndEventIdToInterest < ActiveRecord::Migration[5.1]
  def change
    add_index :interests, :user_id
    add_index :interests, :event_id
  end
end
