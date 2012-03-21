module Flarc

class Ranking < Ygg::PublicModel
  self.table_name = :rankings
  self.inheritance_column = :sti_type

  has_many :pilots,
           :through => :standings

  has_many :standings,
           :class_name => 'Ranking::Standing'

  has_many :sorted_standings,
           :class_name => 'Ranking::Standing',
           :order => 'value DESC, id ASC',
           :conditions => 'value IS NOT NULL'

  has_many :club_standings,
           :class_name => 'Ranking::ClubStanding'

  has_many :sorted_club_standings,
           :class_name => 'Ranking::ClubStanding',
           :order => 'value DESC, id ASC',
           :conditions => 'value IS NOT NULL'

  belongs_to :championship,
             :class_name => 'Championship'

  class Group < Ygg::BasicModel
    self.table_name = :ranking_groups

    has_many :rankins,
             :class_name => 'Ranking'
  end

  class Member < Ygg::BasicModel
    self.table_name = :ranking_members

    belongs_to :ranking,
               :class_name => 'Ranking'

    belongs_to :pilot,
               :class_name => 'Pilot'

#    has_many :history_entries,
#             :class_name => 'Ranking::HistoryEntry'

    serialize :data
  end

  class Standing < Ygg::BasicModel
    self.table_name = :ranking_standings

    belongs_to :ranking,
               :class_name => 'Ranking'

    belongs_to :pilot,
               :class_name => 'Pilot'

    belongs_to :flight,
               :class_name => 'Flight'

    has_many :history_entries,
             :class_name => 'Ranking::Standing::HistoryEntry'

    serialize :data

    class HistoryEntry < Ygg::BasicModel
      self.table_name = :ranking_standing_history_entries

      belongs_to :standing,
                 :class_name => 'Flarc::Ranking::Standing'

      serialize :data
    end
  end

  class ClubStanding < Ygg::BasicModel
    self.table_name = :ranking_club_standings

    belongs_to :ranking,
               :class_name => 'Flarc::Ranking'

    belongs_to :club,
               :class_name => 'Flarc::Club'

    has_many :history_entries,
             :class_name => 'Flarc::Ranking::ClubStanding::HistoryEntry'

    serialize :data

    class HistoryEntry < Ygg::BasicModel
      self.table_name = :ranking_club_standing_history_entries

      belongs_to :club_standing,
                 :class_name => 'Flarc::Ranking::ClubStanding'

      serialize :data
    end
  end


end

end
