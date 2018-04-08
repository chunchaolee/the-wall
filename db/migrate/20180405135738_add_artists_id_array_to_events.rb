class AddArtistsIdArrayToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :artists_id_array, :string, array:true, default: [].to_yaml
  end
end
