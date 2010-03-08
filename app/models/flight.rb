class Flight < ActiveRecord::Base
  belongs_to :pilot
  belongs_to :passenger, :class_name => 'Hel::Person'
  belongs_to :plane
  belongs_to :plane_type_configuration

  has_many :photos,
           :class_name => 'FlightPhoto',
           :dependent => :destroy

  has_many :ranking_flights,
           :dependent => :destroy

  accepts_nested_attributes_for :ranking_flights,
                         :reject_if => proc { |x| x[:status].blank? }
  has_many :rankings,
           :through => :ranking_flights,
           :uniq => true

#  validates_presence_of :pilot, :plane, :takeoff_time, :landing_time, :distance
#  validates_numericality_of :distance

  named_scope :pending, :conditions => [ '(select count(*) from ranking_flights where flight_id=flights.id and status=\'pending\') > 0' ]

  def igc_file_path
    return File.join(Rails.root, 'data', Rails.env, 'flights', self.id.to_s + '.igc')
  end

  def igc_filename
    return ((self.takeoff_time.year % 10).to_s +
           IgcFile::MONTH_IDS[self.takeoff_time.month - 1] +
           IgcFile::DAY_IDS[self.takeoff_time.day - 1] +
           IgcFile::MANUF_IDS[self.igc_fr_manuf] +
           self.igc_fr_serial +
           self.igc_fr_fotd.to_s +
           '.igc').downcase
  end

  def has_igc_file?
    return File.readable?(self.igc_file_path)
  end

  def track
    if !@track
      @track = FlightTrack.new

      begin
        file = IgcFile.open(self.igc_file_path)

        file.read_contents { |x| @track << x }
      rescue
      end
    end

    return @track
  end

  def update_from_igcfile(igc_file, original_filename = nil)

    person = Hel::Person.first(
      :conditions => [ 'LOWER(first_name||last_name) = ? OR ' +
                       'LOWER(last_name||first_name) = ?',
                       igc_file.pilot_name.downcase.tr('^a-z',''),
                       igc_file.pilot_name.downcase.tr('^a-z','') ])

    self.pilot = Pilot.first(:conditions => ['person_id = ?', person.id ]) if person

    if (!self.plane && igc_file.glider_id)
      self.plane = Plane.find_by_registration(igc_file.glider_id.strip.upcase)
    end

    self.takeoff_time = igc_file.takeoff_time
    self.landing_time = igc_file.landing_time

    if original_filename &&
       original_filename.downcase =~ /^.{7}(.)\.igc$/
      self.igc_fr_fotd = $1.to_i
    elsif igc_file.id_from_logger.extension =~ /FLIGHT:[0-9]*/
      self.igc_fr_fotd = $1.to_i
    else
      self.igc_fr_fotd = 1
    end

    self.igc_fr_serial = igc_file.id_from_logger.unique_id
    self.igc_fr_manuf = igc_file.id_from_logger.manufacturer
  end

  def handicap
    return (self.plane_type_configuration ?
              self.plane_type_configuration.handicap :
              self.plane.plane_type.handicap) ||
            self.tmp_fca
  end

  def points
    return nil if !distance

    (self.handicap && self.handicap > 0) ?
      ((self.distance / 1000.0) / self.handicap) :
      0
  end

  def duration
    return self.landing_time - self.takeoff_time
  end

  def encoded_polyline(options = {})
    if options[:force] || (!self.encoded_polyline_cache && !self.track.empty?)
      self.encoded_polyline_cache =
        GMapPolylineEncoder.new(:dp_threshold => 0.001).encode(
            self.track.collect { |x| [x.lat, x.lon] })[:points]
      save
    end

    return self.encoded_polyline_cache
  end
end
