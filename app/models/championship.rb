class Championship < ActiveRecord::Base
  has_many :members,
           :class_name => "ChampionshipPilot"
  has_many :pilots, :through => :members

  has_many :rankings
end
