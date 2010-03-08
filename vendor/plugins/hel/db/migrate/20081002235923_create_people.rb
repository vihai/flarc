class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.timestamps

      t.string :first_name, :limit => 64, :null => false
      t.string :middle_name, :limit => 64
      t.string :last_name, :limit => 64, :null => false
      t.string :nickname, :limit => 32
      t.string :gender, :limit => 1

      t.references :home_location
      t.references :birth_location

      t.string :vat_number, :limit => 16
      t.string :italian_fiscal_code, :limit => 16

      t.text :notes
    end
  end

  def self.down
    drop_table :people
  end
end
