class RemoveArtistIdArrayFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :artist_id_array
  end
end
