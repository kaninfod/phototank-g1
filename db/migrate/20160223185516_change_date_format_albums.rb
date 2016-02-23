class ChangeDateFormatAlbums < ActiveRecord::Migration
  def change
    change_column :albums, :start, :date
    change_column :albums, :start, :date
  end
end
