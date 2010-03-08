class CreatePlaneTypes < ActiveRecord::Migration
  def self.up
    create_table :plane_types do |t|
      t.timestamps
      t.string :manufacturer, :limit => 64, :null => false
      t.string :name, :limit => 32, :null => false
      t.integer :seats
      t.integer :motor
      t.float :handicap
      t.string :link_wp
    end
  end

  def self.down
    drop_table :plane_types
  end
end
