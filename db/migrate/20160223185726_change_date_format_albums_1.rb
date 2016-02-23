class ChangeDateFormatAlbums1 < ActiveRecord::Migration
  def change
    change_column :albums, :start, :date
    change_column :albums, :end, :date
  end
end
