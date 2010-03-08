class CreateFlightPhotos < ActiveRecord::Migration
  def self.up
    create_table :flight_photos do |t|
      t.timestamps

      t.references :flight, :null => false
      t.integer :farm_id, :null => false
      t.integer :server_id, :null => false
      t.string :photo_id, :null => false, :limit => 32
      t.string :secret, :null => false, :limit => 32
      t.float :lat
      t.float :lon
      t.text :url
    end
  end

  def self.down
    drop_table :flight_photos
  end
end
