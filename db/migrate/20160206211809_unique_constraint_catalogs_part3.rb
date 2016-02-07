class UniqueConstraintCatalogsPart3 < ActiveRecord::Migration
  def change
    begin
      add_index :instances, ["photo_id", "catalog_id"], :unique => true
    rescue Exception => e
      puts e
    end 
  end
end