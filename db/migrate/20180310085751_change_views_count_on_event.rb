class ChangeViewsCountOnEvent < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :views_count, :integer, default: 0

    Event.pluck(:id).each do |i|
      Event.reset_counters(i, :views)
    end
  end
end
