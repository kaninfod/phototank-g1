class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.datetime "start"
      t.datetime "end"
      t.string   "make"
      t.string   "model"      
      t.timestamps null: false
    end
  end
end
