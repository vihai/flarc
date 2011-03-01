class RankingFlight < Ygg::BasicModel
  belongs_to :ranking
  belongs_to :flight

#  validates_presence_of :ranking, :flight
end
