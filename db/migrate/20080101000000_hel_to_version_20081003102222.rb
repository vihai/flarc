class HelToVersion20081003102222 < ActiveRecord::Migration
  def self.up
    Engines.plugins["hel"].migrate()
  end

  def self.down
    Engines.plugins["hel"].migrate(0)
  end
end
