class ChangeLengthOfPhotoIdsAlums < ActiveRecord::Migration[5.0]
  def change
     change_column :albums, :photo_ids, :string, :limit => 1024

  end
end
