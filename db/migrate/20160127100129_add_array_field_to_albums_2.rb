class AddArrayFieldToAlbums2 < ActiveRecord::Migration
  def change
    remove_column :albums, :photo_ids
    add_column :albums, :photo_ids, :string
  end
end
