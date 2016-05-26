class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photofiles do |t|
      t.string          :path,  null: false
      t.timestamps    null: false
    end
  end
end
