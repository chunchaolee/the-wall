class AddSpotifyArtistIdOnEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :spotify_artist_id, :string
    remove_column :users, :spotify_artist_id
  end
end
