class RenameColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :fb_connet, :fb_connect
    rename_column :users, :spotify_connet, :spotify_connect
  end
end
