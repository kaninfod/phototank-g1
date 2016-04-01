class DropDoublesTable < ActiveRecord::Migration
  def change
    drop_table :doubles
  end
end
