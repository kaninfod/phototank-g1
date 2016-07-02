class PhotoStatusDefaultValue < ActiveRecord::Migration
  def change
    change_column :photos, :status, :integer, :default => 0
  end
end
