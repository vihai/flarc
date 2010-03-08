class RankingMember < ActiveRecord::Base
  belongs_to :ranking
  belongs_to :pilot

  has_many :history_entries,
           :class_name => "RankingHistoryEntry"

  serialize :data
end
