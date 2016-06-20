class AddImageidToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :map_image_id, :integer
  end
end
