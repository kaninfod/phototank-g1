class AddDatastoreForExternalStorage < ActiveRecord::Migration
  def change
    add_column :catalogs, :ext_store_data, :string
  end
end
