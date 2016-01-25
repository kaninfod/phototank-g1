class AddWatchPathToInstances < ActiveRecord::Migration
  def change
    add_column :catalogs, :watch_path, :string
  end
end
