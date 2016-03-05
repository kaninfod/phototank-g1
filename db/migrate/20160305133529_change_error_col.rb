class ChangeErrorCol < ActiveRecord::Migration
  def change
    rename_column :import_errors, :errors, :error_message
  end
end
