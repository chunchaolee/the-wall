class ModifiedUidOnUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :fb_uid, :uid
  end
end
