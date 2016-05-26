class AddIdFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :original_id, :integer
    add_column :photos, :large_id, :integer
    add_column :photos, :medium_id, :integer
    add_column :photos, :small_id, :integer
  end
end
