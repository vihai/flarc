class FlightTag < Ygg::BasicModel

  self.inheritance_column = :sti_type

  belongs_to :tag,
             :class_name => 'Tag'

  belongs_to :flight,
             :class_name => 'Flight'

  validates_presence_of :tag, :flight

  serialize :data

  def eql?(other)
    return false if !other.kind_of?(self.class)
    return self.tag_id == other.tag_id && self.flight_id == other.flight_id
  end

  def hash
    return self.tag_id * (self.flight_id || 1)
  end

  class Cid2011 < FlightTag
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

      if self.tag.symbol == :cid_2011_naz_club
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

  class Csvva2010 < FlightTag
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

  class Csvva2011 < FlightTag
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
end
