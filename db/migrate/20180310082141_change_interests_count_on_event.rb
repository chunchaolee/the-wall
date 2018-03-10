class ChangeInterestsCountOnEvent < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :intersets_count, :interests_count
    change_column :events, :interests_count, :integer, default: 0

    Event.pluck(:id).each do |i|
      Event.reset_counters(i, :interests)
    end

  end
end
