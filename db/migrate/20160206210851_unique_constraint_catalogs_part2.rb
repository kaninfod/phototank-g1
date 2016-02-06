class UniqueConstraintCatalogsPart2 < ActiveRecord::Migration
  def change
    add_index_options :instances, [:photo_id, :catalog_id], :unique => true
  end
end
