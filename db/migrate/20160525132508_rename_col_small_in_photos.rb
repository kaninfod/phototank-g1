class RenameColSmallInPhotos < ActiveRecord::Migration
  def change
    rename_column :photos, :small_id, :thumb_id
  end
end
