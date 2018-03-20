class AddSpotifyArtistIdOnUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :spotify_artist_id, :string
  end
end
