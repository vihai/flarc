class CreateAlptherm < ActiveRecord::Migration
  def self.up
    create_table :alptherm_sources do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :site_param

      t.timestamps
    end

    create_table :alptherm_history_entries do |t|
      t.timestamps
      t.timestamp :taken_at, :null => false
      t.string :source, :null => false
      t.text :data, :null => false
    end
  end

  def self.down
    drop_table :alptherm_sources
    drop_table :alptherm_history_entries
  end
end
