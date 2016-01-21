class AddCityToLocations < ActiveRecord::Migration
  def change
    add_column :albums, :city, :string
  end
end
