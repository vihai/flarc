class RankingHistoryEntry < Ygg::BasicModel
  belongs_to :ranking_standing

  serialize :data
end
