class ChangeFieldLength < ActiveRecord::Migration
  def change
    change_column :catalogs, :ext_store_data, :string, :limit => 1024
  end
end
