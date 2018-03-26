class ChangeColumnTimeOnEvent < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :time, :timestamptz
  end
end
