class ChampionshipPilot < ActiveRecord::Base
  belongs_to :pilot
  belongs_to :championship

  attr_accessor :enabled
end
