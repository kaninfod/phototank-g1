class Addforeignkeys < ActiveRecord::Migration
  def change
        add_foreign_key :photos, :locations
  end
end
