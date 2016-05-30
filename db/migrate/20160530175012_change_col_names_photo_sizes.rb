class ChangeColNamesPhotoSizes < ActiveRecord::Migration
  def change
    rename_column :photos, :thumb_id, :tm_id
    rename_column :photos, :medium_id, :md_id
    rename_column :photos, :large_id, :lg_id
    rename_column :photos, :original_id, :org_id
  end
end
