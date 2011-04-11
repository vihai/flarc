class CreatePlaneTypeConfigurations < ActiveRecord::Migration
  def self.up
    create_table :plane_type_configurations do |t|
      t.timestamps

      t.string :name, :limit => 32, :null => false
      t.references :plane_type, :null => false
      t.float :handicap, :null => false
      t.float :club_handicap, :null => false
    end
  end

  def self.down
    drop_table :plane_type_configurations
  end
end
