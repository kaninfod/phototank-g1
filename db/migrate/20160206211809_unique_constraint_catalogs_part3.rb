class UniqueConstraintCatalogsPart3 < ActiveRecord::Migration
  def change
    add_index :instances, ["photo_id", "catalog_id"], :unique => true
  end
end
