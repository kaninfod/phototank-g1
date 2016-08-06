class AddTagsColumnToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :tags, :string,  default: []
    add_column :albums, :like, :boolean
  end
end
