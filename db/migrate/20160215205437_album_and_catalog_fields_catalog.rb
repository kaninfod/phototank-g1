class AlbumAndCatalogFieldsCatalog < ActiveRecord::Migration
  def change
    add_column :catalogs, :sync_from_albums, :string
    add_column :catalogs, :sync_from_catalog, :integer
  end
end
