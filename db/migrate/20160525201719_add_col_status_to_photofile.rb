class AddColStatusToPhotofile < ActiveRecord::Migration
  def change
    add_column :photofiles, :status, :integer
  end
end
