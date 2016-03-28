class AddClonemodeToCatalog < ActiveRecord::Migration
  def change
    add_column :catalogs, :clone_mode, :boolean
  end
end
