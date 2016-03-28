class AddPhashColumnToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :phash, :text
  end
end
