require 'active_record/fixtures'

class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.timestamps
      t.string :a2, :limit => 2, :null => false
      t.string :a3, :limit => 3, :null => false
      t.integer :num, :null => false
      t.string :name, :null => false
      t.string :area_code, :limit => 4
      t.boolean :cities_are_authoritative
    end

    add_index :countries, :a2, :unique
    add_index :countries, :a3, :unique
    add_index :countries, :num, :unique

    Hel::Country.delete_all
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__), "data"), "countries")
  end

  def self.down
    drop_table :countries
  end
end
