class Ranking < ActiveRecord::Base
  has_many :standings,
           :class_name => "RankingStanding"
  has_many :pilots, :through => :standings

  has_many :sorted_standings,
           :class_name => "RankingStanding",
           :order => "value DESC, id ASC",
           :conditions => "value IS NOT NULL"

  has_many :ranking_flights
  has_many :flights, :through => :ranking_flights

  belongs_to :group, :class_name => "RankingGroup"
end
