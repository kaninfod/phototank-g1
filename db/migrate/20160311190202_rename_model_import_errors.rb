class RenameModelImportErrors < ActiveRecord::Migration
  def change
    rename_table :import_errors, :jobs
  end
end
