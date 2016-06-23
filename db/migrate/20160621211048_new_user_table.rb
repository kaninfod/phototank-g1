class NewUserTable < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users do |t|
          t.string :name
          t.string :provider
          t.string :uid

          t.timestamps
        end




  end
end
