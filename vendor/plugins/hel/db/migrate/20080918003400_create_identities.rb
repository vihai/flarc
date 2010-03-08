class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      t.timestamps

      t.references :person
      t.string :fqdn, :limit => 128, :null => false
      t.string :password, :limit => 32
      t.boolean :email_verified
      t.string :uuid, :limit => 22,  :null => false
    end
    
    add_index 'identities', ['fqdn'], :unique => true
    add_index 'identities', ['uuid'], :unique => true
    add_index 'identities', ['person_id'], :unique => false
  end

  def self.down    
    drop_table :identities
  end
end
