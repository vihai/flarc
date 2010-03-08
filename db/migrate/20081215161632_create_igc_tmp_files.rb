class CreateIgcTmpFiles < ActiveRecord::Migration
  def self.up
    create_table :igc_tmp_files do |t|
      t.timestamps
      t.string :original_filename, :limit => 64
      t.references :pilot
      t.references :club
    end
  end

  def self.down
    drop_table :igc_tmp_files
  end
end
