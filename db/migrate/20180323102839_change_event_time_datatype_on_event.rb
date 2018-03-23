class ChangeEventTimeDatatypeOnEvent < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :time, :time 
  end
end
