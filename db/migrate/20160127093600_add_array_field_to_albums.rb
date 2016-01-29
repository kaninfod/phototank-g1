class AddArrayFieldToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :photo_ids, :string, array: true, default: []
  end
end
