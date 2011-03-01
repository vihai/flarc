class Ranking < Ygg::PublicModel
  has_many :standings,
           :class_name => 'RankingStanding'
  has_many :pilots, :through => :standings

  has_many :sorted_standings,
           :class_name => 'RankingStanding',
           :order => 'value DESC, id ASC',
           :conditions => 'value IS NOT NULL'

  belongs_to :group, :class_name => 'RankingGroup'

  belongs_to :championships
end
