class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.timestamps
      t.references :pilot, :null => false
      t.references :plane, :null => false
      t.references :plane_type_configuration
      t.timestamp :takeoff_time, :null => false
      t.timestamp :landing_time, :null => false
      t.float :distance
      t.float :speed
      t.references :passenger
      t.string :passenger_name, :limit => 64

      t.string :status, :default => "unchecked", :null => false

      t.boolean :private, :null => false

      t.date :logger_date

      t.text :user_notes
      t.text :admin_notes

      t.text :encoded_polyline_cache

      t.string :igc_fr_serial, :limit => 3
      t.integer :igc_fr_fotd
    end
  end

  def self.down
    drop_table :flights
  end
end
