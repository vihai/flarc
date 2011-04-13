class CreateRankings < ActiveRecord::Migration
  def self.up
    create_table :rankings do |t|
      t.timestamps
      t.string :sybmol, :limit => 32, :unique => true
      t.string :name, :unique => true
      t.references :group
      t.references :championship
      t.string :driver, :limit => 16
      t.boolean :official
      t.integer :priority
      t.string :color, :limit => 6
      t.datetime :generated_at
    end
    add_index :rankings, :symbol, :unique => true

    create_table :ranking_groups do |t|
      t.timestamps
      t.string :name
    end

    create_table :championships do |t|
      t.timestamps
      t.string :name
      t.string :symbol
    end
    add_index :championships, :symbol, :unique => true

    create_table :championship_pilots do |t|
      t.references :championship
      t.references :pilot
      t.string :csvva_pilot_level, :limit => 32
      t.string :cid_category, :limit => 32
    end
    add_index :championship_pilots, :championship_id
    add_index :championship_pilots, :pilot_id
    add_index :championship_pilots, [ :championship_id, :pilot_id ], :unique => true

    create_table :championship_flights do |t|
      t.timestamps
      t.references :championship
      t.references :flight
      t.string :sti_type
      t.string :status, :limit => 8
      t.text :data
      t.integer :distance
      t.float :speed
      t.string :cid_ranking, :limit => 32
    end
    add_index :championship_flights, :championship_id
    add_index :championship_flights, :flight_id
    add_index :championship_flights, [ :championship_id, :flight_id ], :unique => true

    create_table :ranking_standings do |t|
      t.timestamps
      t.references :ranking, :null => false
      t.references :pilot, :null => false
      t.references :flight
      t.integer :position
      t.float :value
      t.text :data
    end
    add_index :ranking_standings, [ :ranking_id, :pilot_id ], :unique => true
    add_index :ranking_standings, :ranking_id
    add_index :ranking_standings, :pilot_id
    add_index :ranking_standings, :flight_id
  end

  def self.down
    drop_table :championship_flights
    drop_table :championship_pilots
    drop_table :championships
    drop_table :rankings
  end
end
