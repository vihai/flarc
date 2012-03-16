class Championship
class Flight

class Csvva2011 < Flight
  validates_presence_of :distance
  validates_numericality_of :distance

  def handicap
    return self.flight.plane_type_configuration ?
             self.flight.plane_type_configuration.handicap :
             self.flight.plane.plane_type.handicap
  end

  def points
    return nil if !distance

    (handicap && handicap > 0) ?
      ((distance / 1000.0) / handicap) :
      0
  end
end

end
end
