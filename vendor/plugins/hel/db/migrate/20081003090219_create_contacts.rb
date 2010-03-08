class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.timestamps

      t.references :identity
      t.references :organization
      t.references :contact_area
      t.references :contact_role

      t.text :notes
    end
  end

  def self.down
    drop_table :contacts
  end
end
