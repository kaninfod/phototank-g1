class UniqueConstraintCatalogs < ActiveRecord::Migration
  def change
    remove_index(:instances, :catalog_id)
    remove_index(:instances, :photo_id)
    
  end
end
