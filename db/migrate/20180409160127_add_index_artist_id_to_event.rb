class AddIndexArtistIdToEvent < ActiveRecord::Migration[5.1]
  def change
    add_index :events, :artist_id
  end
end
