class CreatePlanes < ActiveRecord::Migration
  def self.up
    create_table :planes do |t|
      t.timestamps
      t.string :registration, :limit => 8, :null => false
      t.references :plane_type, :null => false
    end
  end

  def self.down
    drop_table :planes
  end
end
