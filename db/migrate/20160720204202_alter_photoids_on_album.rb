class AlterPhotoidsOnAlbum < ActiveRecord::Migration
  def change
    change_column :albums, :photo_ids, :string#, array: true, default: []
  end
end
