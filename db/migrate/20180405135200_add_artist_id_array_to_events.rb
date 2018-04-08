class AddArtistIdArrayToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :artist_id_array, :integer, array:true, default: [].to_yaml
  end
end
