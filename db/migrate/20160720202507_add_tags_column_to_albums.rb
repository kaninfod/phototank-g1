class AddTagsColumnToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :tags, :string#, array: true, default: []
    add_column :albums, :like, :boolean
  end
end
