class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.timestamps
      t.string :name

      # Registered Office address
      t.string :ro_address
      t.references :ro_city
      t.string :ro_zip, :limit => 8

      # Operational Address
      t.string :op_address
      t.references :op_city
      t.string :op_zip, :limit => 8

      # Billing Address
      t.string :billing_address
      t.references :billing_city
      t.string :billing_zip, :limit => 8

      t.string :vat_number, :limit => 16
      t.string :italian_fiscal_code, :limit => 16
      t.text :notes
    end
  end

  def self.down
    drop_table :organizations
  end
end
