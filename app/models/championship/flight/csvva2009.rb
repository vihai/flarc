class Championship
class Flight

class Csvva2009 < Flight
  validates_presence_of :distance
  validates_numericality_of :distance

  def handicap
    return self.flight.plane_type_configuration ?
             self.flight.plane_type_configuration.handicap :
             self.flight.plane.plane_type.handicap
  end

  def points
    return nil if !distance

    (self.handicap && self.handicap > 0) ?
      ((self.distance / 1000.0) / self.handicap) :
      0
  end
end

end
end
