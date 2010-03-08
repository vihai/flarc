
class CreateCredentials < ActiveRecord::Migration
  def self.up
    create_table :credentials do |t|
      t.timestamps

      t.references :identity, :null => false
      t.string :scheme, :limit => 32, :null => false
      t.string :encoding, :limit => 32, :null => false
      t.string :diameter, :limit => 32, :null => false
      t.text :data, :null => false
    end
    
    add_index 'credentials', ['identity_id'], :unique => false
    add_index 'credentials', ['identity_id', 'scheme'], :unique => false
    add_index 'credentials', ['identity_id', 'scheme', 'diameter'], :unique => false
  end

  def self.down
    drop_table :identities
  end
end
