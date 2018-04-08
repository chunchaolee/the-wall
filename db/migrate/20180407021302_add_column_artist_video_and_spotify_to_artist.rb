class AddColumnArtistVideoAndSpotifyToArtist < ActiveRecord::Migration[5.1]
  def change
    add_column :artists, :artist_video, :string
    add_column :artists, :artist_spotify_id, :string
  end
end
