class SetTypeForPhotoFiles < ActiveRecord::Migration
  def change
    Photofile.all.each do |pf|
      size = pf.path.split("/")[-1].split('_')[1]
      pf.update_columns({:size => size})
    end
  end
end
