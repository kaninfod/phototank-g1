class AddCountryToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :country, :string
  end
end
