class ChangeClassCol < ActiveRecord::Migration
  def change
    rename_column :import_errors, :class, :error_type
  end
end
