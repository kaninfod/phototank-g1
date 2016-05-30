class AddTimestampsToInstances < ActiveRecord::Migration
  def change
    add_column(:instances, :created_at, :datetime)
    add_column(:instances, :updated_at, :datetime)
  end
end
