class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :fb_connet, :string
    add_column :users, :spotify_connet, :string

    remove_column :users, :avatar
    remove_column :users, :is_artist
  end
end
