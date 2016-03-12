class AlterInstancesRev < ActiveRecord::Migration
  def change
    add_column :instances, :rev, :string
  end
end
