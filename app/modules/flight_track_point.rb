
class FlightTrackPoint < Struct.new(:sequence, :logged_at, :lat, :lon, :validity, :press_alt, :gnss_alt, :ext)
  def initialize
    super
    self.ext = {}
  end

  def rough_distance(other)
    Math::sqrt((self.lat - other.lat)**2 + (self.lon - other.lon)**2)
  end

  RADIANS = 180 / Math::PI
  EARTH_RADIUS = 6371000

  def distance(other)
    begin
      Math.acos(Math.sin(self.lat / RADIANS) * Math.sin(other.lat / RADIANS) +
        Math.cos(self.lat / RADIANS) * Math.cos(other.lat / RADIANS) *
        Math.cos((self.lon / RADIANS) - (other.lon / RADIANS))) * EARTH_RADIUS
    rescue Errno::EDOM, Math::DomainError
      # May happen when acos argument should be 1 but is rounded to something a bit greater than 1
      0
    end
  end

end
