class ChangeRequiredFieldsPhoto < ActiveRecord::Migration
  def change
    change_column_null :photos, :filename, true 
    change_column_null :photos, :date_taken, true
    change_column_null :photos, :path, true
    change_column_null :photos, :file_thumb_path, true          
    change_column_null :photos, :file_extension, true
    change_column_null :photos, :file_size, true

    
    
  end
end
