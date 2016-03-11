class AlterJobsColumnsStatus < ActiveRecord::Migration
  def change
    change_column :jobs, :status, :integer
  end
end
