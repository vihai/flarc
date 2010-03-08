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

    add_index :rankings, :symbol

    create_table :ranking_members do |t|
      t.timestamps
      t.references :ranking
      t.references :pilot
      t.integer :position
      t.float :value
      t.text :data
    end

    add_index :ranking_members, :ranking_id
    add_index :ranking_members, :pilot_id
    add_index :ranking_members, :position
    add_index :ranking_members, [ :ranking_id, :pilot_id ], :unique => true

    create_table :ranking_flights do |t|
      t.timestamps
      t.references :ranking
      t.references :flight
      t.string :status, :limit => 8
    end

    add_index :ranking_flights, :ranking_id
    add_index :ranking_flights, :flight_id
    add_index :ranking_flights, [ :ranking_id, :flight_id ], :unique => true

    create_table :ranking_groups do |t|
      t.timestamps
      t.string :name
    end

    create_table :championships do |t|
      t.timestamps
      t.string :name
    end

    create_table :championship_pilots do |t|
      t.references :championship
      t.references :pilot
    end
  end

  def self.down
    drop_table :championship_pilots
    drop_table :championships
    drop_table :ranking_flights
    drop_table :ranking_members
    drop_table :rankings
  end
end
