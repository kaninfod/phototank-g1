class AlbumPhotoArraySize < ActiveRecord::Migration
  def change
    change_column :albums, :photo_ids, :text
  end
end
