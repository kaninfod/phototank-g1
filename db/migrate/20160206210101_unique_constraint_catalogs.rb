class UniqueConstraintCatalogs < ActiveRecord::Migration
  def change
    begin
      remove_index(:instances, :catalog_id)
      remove_index(:instances, :photo_id)
    rescue Exception => e
      puts e
    end 
  end
end
