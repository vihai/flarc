class CreateRankingHistory < ActiveRecord::Migration

    create_table :ranking_history_entries do |t|
      t.timestamps

      t.references :ranking_standing, :null => false
      t.datetime :snapshot_time
      t.integer :position
      t.float :value
      t.text :data
    end

    add_index :ranking_history_entries, :ranking_standing_id
  end

  def self.down
    drop_table :ranking_history_entry
  end
end
