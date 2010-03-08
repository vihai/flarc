class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.timestamps

      t.text :address
      t.text :city
      t.string :zip, :limit => 10
      t.text :state
      t.string :country, :limit => 2
      t.float :lat
      t.float :lon
      t.string :geocoder, :limit => 16
      t.string :geocode_precision, :limit => 16
    end
  end

  def self.down
    drop_table :locations
  end
end
