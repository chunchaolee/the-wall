class AddSpecialIdForEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :special_id, :string
  end
end
