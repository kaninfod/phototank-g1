class AlterJobsTable < ActiveRecord::Migration
  def change
    rename_column :jobs, :error_type, :jobs_type
    rename_column :jobs, :error_message, :jobs_errors
    remove_column :jobs, :path
    add_column :jobs, :arguments, :string
    add_column :jobs, :completed_at, :datetime
    add_column :jobs, :queue, :string
    add_column :jobs, :status, :boolean
  end
end
