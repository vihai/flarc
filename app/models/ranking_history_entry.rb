class RankingHistoryEntry < ActiveRecord::Base
  belongs_to :pilot

  belongs_to :ranking_standing

  serialize :data
end
