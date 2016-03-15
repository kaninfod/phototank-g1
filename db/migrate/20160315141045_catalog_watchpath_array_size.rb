class CatalogWatchpathArraySize < ActiveRecord::Migration
  def change
    change_column :catalogs, :watch_path, :text
  end
end
