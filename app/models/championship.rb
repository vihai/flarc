class Championship < Ygg::PublicModel
  has_many :championship_pilots,
           :class_name => '::Championship::Pilot'
  has_many :pilots, :through => :championship_pilots

  has_many :rankings

  has_many :championship_flights,
           :class_name => '::Championship::Flight',
           :dependent => :destroy,
           :embedded => true

  has_many :flights, :through => :championship_flights

  class Flight < Ygg::BasicModel

    set_table_name 'championship_flights'

    self.inheritance_column = :sti_type

    belongs_to :championship,
               :class_name => '::Championship'

    belongs_to :flight,
               :class_name => '::Flight'

    validates_presence_of :championship, :flight

    serialize :data

    class Cid2011 < Flight
      before_save do
        nd = {}
        self.data ||= {}
        self.data.each { |k,v| nd[k.to_sym] = v }
        self.data = nd
        self.data[:task_eval] = self.data[:task_eval].to_sym
        self.data[:task_type] = self.data[:task_type].to_sym
      end

      def handicap
        return (self.flight.plane_type_configuration ?
                  self.flight.plane_type_configuration.handicap :
                  self.flight.plane.plane_type.handicap)
      end

      def club_handicap
        return (self.flight.plane_type_configuration ?
                  self.flight.plane_type_configuration.club_handicap :
                  self.flight.plane.plane_type.club_handicap)
      end

      def points
        return nil if !distance

        if self.championship.symbol.to_sym == :cid_2011 &&
           self.cid_ranking.to_sym == :naz_club
          hcap = club_handicap
        else
          hcap = handicap
        end

        return nil if !hcap

        pts = (distance / 1000.0) / hcap

        case self.data[:task_type]
        when :round_trip ; pts = pts * 1.3
        when :fai_triangle ; pts = pts * 1.4
        when :straight_line ; pts = pts * 1.6
        end

        if data[:task_eval] == :declared
          if data[:task_type] == :simple_triangle
            pts = pts * 1.2
          end

          if data[:task_completed]
            pts = pts * 1.1
          end
        end

        pts
      end
    end

    class Csvva2011 < Flight
      def handicap
        return (self.flight.plane_type_configuration ?
                  self.flight.plane_type_configuration.handicap :
                  self.flight.plane.plane_type.handicap) ||
                self.flight.tmp_fca
      end

      def points
        return nil if !distance

        (handicap && handicap > 0) ?
          ((distance / 1000.0) / handicap) :
          0
      end
    end

    class Csvva2010 < Flight
      def handicap
        return (self.flight.plane_type_configuration ?
                  self.flight.plane_type_configuration.handicap :
                  self.flight.plane.plane_type.handicap) ||
                self.flight.tmp_fca
      end

      def points
        return nil if !distance

        (self.handicap && self.handicap > 0) ?
          ((self.distance / 1000.0) / self.handicap) :
          0
      end
    end

    class Csvva2009 < Flight
      def handicap
        return (self.flight.plane_type_configuration ?
                  self.flight.plane_type_configuration.handicap :
                  self.flight.plane.plane_type.handicap) ||
                self.flight.tmp_fca
      end

      def points
        return nil if !distance

        (self.handicap && self.handicap > 0) ?
          ((self.distance / 1000.0) / self.handicap) :
          0
      end
    end

  end

  class Pilot < Ygg::BasicModel
    set_table_name 'championship_pilots'

    self.inheritance_column = :sti_type

    belongs_to :pilot,
               :class_name => '::Pilot'
    belongs_to :championship,
               :class_name => '::Championship'

    validates_presence_of :pilot, :championship

    class Cid2011 < Pilot
    end

    class Csvva2011 < Pilot
    end

    class Csvva2010 < Pilot
    end

    class Csvva2009 < Pilot
    end
  end
end
