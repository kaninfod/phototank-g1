class RenameClonemodeToimportmode < ActiveRecord::Migration
  def change
    rename_column :catalogs, :clone_mode, :import_mode
  end
end
