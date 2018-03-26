class AddThewallArtistIdToArtists < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :thewall_artist_id, :integer
  end
end
