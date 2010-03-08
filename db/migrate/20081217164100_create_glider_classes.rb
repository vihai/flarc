class CreateGliderClasses < ActiveRecord::Migration
  def self.up
    create_table :glider_classes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :glider_classes
  end
end
