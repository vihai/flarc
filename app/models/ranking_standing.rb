class RankingStanding < Ygg::BasicModel
  belongs_to :ranking

  belongs_to :pilot,
             :class_name => 'Flarc::Pilot'

  belongs_to :flight

  has_many :history_entries,
           :class_name => "RankingHistoryEntry"

  serialize :data
#  serialize :data, Hash
end
