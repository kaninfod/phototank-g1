class ChangePrecisionB < ActiveRecord::Migration
  def change
    change_column :photos, :longitude, :float
    change_column :photos, :latitude, :float
    change_column :locations, :longitude, :float
    change_column :locations, :latitude, :float
  end
end
