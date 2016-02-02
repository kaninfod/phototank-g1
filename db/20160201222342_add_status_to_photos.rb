class AddStatusToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :status, :integer
  end
end
