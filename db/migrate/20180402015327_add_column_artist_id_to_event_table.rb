class AddColumnArtistIdToEventTable < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :artist_id, :string
  end
end
