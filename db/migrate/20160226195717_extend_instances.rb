class ExtendInstances < ActiveRecord::Migration
  def change
    add_column :instances, :size, :integer
    add_column :instances, :modified, :datetime
    add_column :instances, :status, :integer
  end
end
