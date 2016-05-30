class AddSizeColToPhotofiles < ActiveRecord::Migration
  def change
    add_column :photofiles, :size, :string
  end
end
