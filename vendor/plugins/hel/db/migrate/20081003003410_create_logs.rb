class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.timestamps

      t.datetime :log_time, :null => false
      t.references :identity, :null => false
      t.string :operation, :limit => 16
      t.string :object_class_name
      t.integer :object_id
      t.text :descr, :null => false
      t.text :changes
      t.text :notes

      t.string :http_remote_addr, :limit => 64
      t.integer :http_remote_port
      t.string :http_server_addr, :limit => 64
      t.integer :http_server_port
      t.text :http_host
      t.text :http_url
      t.text :http_user_agent
      t.text :http_referer
      t.text :http_x_forwarded_for
      t.text :http_via
    end
  end

  def self.down
    drop_table :logs
  end
end
