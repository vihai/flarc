class CreateAlpthermSources < ActiveRecord::Migration
  def self.up
    create_table :alptherm_sources do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.string :site_param

      t.timestamps
    end
  end

  def self.down
    drop_table :alptherm_sources
  end
end
