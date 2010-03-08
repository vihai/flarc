
class FlightTrackPoint < Hash
  def sequence
    self[:sequence]
  end

  def logged_at
    self[:logged_at]
  end

  def lat
    self[:lat]
  end

  def lon
    self[:lon]
  end

  def lng
    self[:lon]
  end

  def validity
    self[:validity]
  end

  def press_alt
    self[:press_alt]
  end

  def gnss_alt
    self[:gnss_alt]
  end

  def accuracy
    self[:accuracy]
  end
end

