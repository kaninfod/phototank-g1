class ChangeDataType < ActiveRecord::Migration
  def change
    change_column :locations, :longitude, :float
    change_column :locations, :latitude, :float
  end
end
