class RenameAlbumTypeColumn < ActiveRecord::Migration
  def change
    rename_column :albums, :type, :album_type
  end
end
