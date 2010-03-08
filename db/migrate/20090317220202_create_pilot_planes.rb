class CreatePilotPlanes < ActiveRecord::Migration
  def self.up
    create_table :pilot_planes do |t|
      t.timestamps

      t.references :pilot
      t.references :plane
    end
  end

  def self.down
    drop_table :pilot_planes
  end
end
