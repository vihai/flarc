class CreateContactRoles < ActiveRecord::Migration
  def self.up
    create_table :contact_roles do |t|
      t.timestamps

      t.string :name, :limit => 32
      t.text :descr
    end
  end

  def self.down
    drop_table :contact_roles
  end
end
