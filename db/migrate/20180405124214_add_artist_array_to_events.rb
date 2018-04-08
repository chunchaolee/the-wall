class AddArtistArrayToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :artist_array, :string, array:true, default: [].to_yaml
  end
end
