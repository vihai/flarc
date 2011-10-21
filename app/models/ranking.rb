class Ranking < Ygg::PublicModel
  has_many :standings,
           :class_name => 'Ranking::Standing'

  has_many :pilots,
           :through => :standings

  has_many :sorted_standings,
           :class_name => 'Ranking::Standing',
           :order => 'value DESC, id ASC',
           :conditions => 'value IS NOT NULL'

  belongs_to :championships

  class Group < Ygg::BasicModel
    set_table_name 'ranking_groups'

    has_many :rankins,
             :class_name => 'Ranking'
  end

  class Member < Ygg::BasicModel
    set_table_name 'ranking_members'

    belongs_to :ranking,
               :class_name => 'Ranking'

    belongs_to :pilot,
               :class_name => 'Pilot'
  
    has_many :history_entries,
             :class_name => 'Ranking::HistoryEntry'
  
    serialize :data
  end

  class Standing < Ygg::BasicModel
    set_table_name 'ranking_standings'

    belongs_to :ranking,
               :class_name => 'Ranking'
  
    belongs_to :pilot,
               :class_name => 'Pilot'
  
    belongs_to :flight,
               :class_name => 'Flight'
  
    has_many :history_entries,
             :class_name => "RankingHistoryEntry"
  
    serialize :data

    class HistoryEntry < Ygg::BasicModel
      set_table_name 'ranking_history_entries'

      belongs_to :standing,
                 :class_name => 'Ranking::Standing'
    
      serialize :data
    end
  end

  class ClubStanding < Ygg::BasicModel
    set_table_name 'ranking_club_standing'

    belongs_to :ranking,
               :class_name => 'Ranking'
  
    belongs_to :club,
               :class_name => 'Club'
  
#    has_many :history_entries,
#             :class_name => 'ClubRankingHistoryEntry'
  
    serialize :data

    class HistoryEntry < Ygg::BasicModel
      belongs_to :standing,
                 :class_name => 'Ranking::ClubStanding'
    
      serialize :data
    end
  end


end
