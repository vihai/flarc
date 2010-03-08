class CreatePilots < ActiveRecord::Migration
  def self.up
    create_table :pilots do |t|
      t.timestamps
      t.references :person, :null => false, :unique => true
      t.references :club
    end

#    add_index :pilots, :person_id
  end

  def self.down
    drop_table :pilots
  end
end
