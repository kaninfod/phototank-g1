class AlterJobsColumns < ActiveRecord::Migration
  def change
    rename_column :jobs, :jobs_type, :job_type
    rename_column :jobs, :jobs_errors, :job_error
  end
end
