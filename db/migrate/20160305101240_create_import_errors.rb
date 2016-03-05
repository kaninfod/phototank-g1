class CreateImportErrors < ActiveRecord::Migration
  def change
    create_table :import_errors do |t|
      t.timestamps null: false
      t.string  "class"
      t.string  "path"
      t.string  "errors"
    end
  end
end
