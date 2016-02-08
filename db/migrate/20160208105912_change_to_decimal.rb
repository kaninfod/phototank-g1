class ChangeToDecimal < ActiveRecord::Migration
  def change
    change_column :photos, :longitude, :decimal, :precision => 16, :scale => 10
    change_column :photos, :latitude,  :decimal, :precision => 16, :scale => 10
    change_column :locations, :longitude,  :decimal, :precision => 16, :scale => 10
    change_column :locations, :latitude,  :decimal, :precision => 16, :scale => 10
  end
end
