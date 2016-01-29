class AddArrayFieldToAlbums1 < ActiveRecord::Migration
  def change
    change_column :albums, :photo_ids, :string
  end
end
