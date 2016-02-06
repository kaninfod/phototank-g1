class AddColumnToCatalog < ActiveRecord::Migration
  def change
    remove_index "instances", ["catalog_id"], name: "index_instances_on_catalog_id"
    remove_index "instances", ["photo_id"], name: "index_instances_on_photo_id"
    add_column :catalogs, :type, :string
  end
end
