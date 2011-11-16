class Geolocation < ActiveRecord::Migration
  def up
    rename_column :clubs, :lat, :latitude
    rename_column :clubs, :lng, :longitude
    add_column :clubs, :address, :string
    
    # add_column :users, :latitude, :float
    # add_column :users, :longitude, :float
    add_column :users, :zipcode, :string
  end

  def down
    rename_column :clubs, :latitude, :lat
    rename_column :clubs, :longitude, :lng
    remove_column :clubs, :address
    
    # remove_column :users, :latitude
    # remove_column :users, :longitude
    remove_column :users, :zipcode
  end
end
