class ExtendUserTable < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :email, :string
  end
end
