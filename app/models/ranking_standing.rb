class RankingStanding < ActiveRecord::Base
  belongs_to :ranking
  belongs_to :pilot
  belongs_to :flight

  has_many :history_entries,
           :class_name => "RankingHistoryEntry"

  serialize :data
end
