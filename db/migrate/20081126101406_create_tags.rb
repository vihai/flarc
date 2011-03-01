class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.timestamps
      t.string :symbol, :limit => 32, :unique => true
      t.string :name, :unique => true
      t.references :group
      t.boolean :requires_approval
      t.string :color, :limit => 6
      t.text :icon
    end

    add_index :tags, :symbol

    create_table :flight_tags do |t|
      t.timestamps
      t.references :tag
      t.references :flight
      t.string :status, :limit => 8
    end

    add_index :flight_tags, :tag_id
    add_index :flight_tags, :flight_id
    add_index :flight_tags, [ :tag_id, :flight_id ], :unique => true

    create_table :tag_groups do |t|
      t.timestamps
      t.string :name
    end
  end

  def self.down
    drop_table :tag_groups
    drop_table :flight_tags
    drop_table :tags
  end
end
