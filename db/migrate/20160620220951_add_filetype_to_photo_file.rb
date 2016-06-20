class AddFiletypeToPhotoFile < ActiveRecord::Migration
  def change
    add_column :photofiles, :filetype, :string
  end
end
