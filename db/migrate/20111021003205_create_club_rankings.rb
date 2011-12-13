class CreateClubRankings < ActiveRecord::Migration
  def self.up
    create_table :ranking_club_standings do |t|
      t.timestamps
      t.references :ranking, :null => false
      t.references :club, :null => false
      t.integer :position
      t.float :value
      t.text :data
    end
    add_index :ranking_club_standings, [ :ranking_id, :club_id ], :unique => true
    add_index :ranking_club_standings, :ranking_id
    add_index :ranking_club_standings, :club_id

    create_table :ranking_club_standing_history_entries do |t|
      t.timestamps

      t.references :club_standing, :null => false
      t.datetime :snapshot_time
      t.integer :position
      t.float :value
      t.text :data
    end
    add_index :ranking_club_standing_history_entries, :standing_id
  end

  def self.down
    drop_table :ranking_club_standings_history_entry
    drop_table :ranking_club_standings
  end
end
