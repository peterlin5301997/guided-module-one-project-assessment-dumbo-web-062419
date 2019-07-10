class AddLatLonToCity < ActiveRecord::Migration[5.2]
  def change
  	add_column :cities, :lat, :integer
  	add_column :cities, :lon, :integer
  end
end
