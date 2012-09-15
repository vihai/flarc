module Flarc

class Flight < Ygg::PublicModel
  self.table_name = :flights

  belongs_to :pilot,
             :class_name => 'Flarc::Pilot'
#  validates_presence_of :pilot

  belongs_to :old_pilot,
             :class_name => 'Flarc::OldPilot'

  belongs_to :passenger,
             :class_name => 'Ygg::Core::Person'

  belongs_to :plane,
             :class_name => 'Flarc::Plane'
  validates_presence_of :plane_id

  belongs_to :plane_type_configuration,
             :class_name => 'Flarc::PlaneType::Configuration'

  has_many :photos,
           :class_name => 'Flarc::FlightPhoto',
           :dependent => :destroy

  has_many :championship_flights,
           :class_name => 'Flarc::Championship::Flight',
           :dependent => :destroy,
           :embedded => true
  accepts_nested_attributes_for :championship_flights, :allow_destroy => true

  has_many :championships,
           :through => :championship_flights,
           :uniq => true

  interface :rest do
  end

  def championship_flight(symbol)
    championship_flights.joins(:championship).where('championships.symbol' => symbol).first
  end

#  validates_presence_of :pilot, :plane, :takeoff_time, :landing_time, :distance
#  validates_numericality_of :distance

  scope :pending, lambda { joins(:flight_tags).joins(:tags).
                           where('tags.symbol' => 'csvva_2010', 'flight_tags.status' => 'pending') }

  def igc_file_path
    return File.join(Rails.root, 'db', 'igc_files', Rails.env, 'flights', self.id.to_s + '.igc')
  end

  def igc_filename
    return ((self.takeoff_time.year % 10).to_s +
           IgcFile::MONTH_IDS[self.takeoff_time.month - 1].to_s +
           IgcFile::DAY_IDS[self.takeoff_time.day - 1].to_s +
           IgcFile::MANUF_IDS[self.igc_fr_manuf].to_s +
           self.igc_fr_serial.to_s +
           self.igc_fr_fotd.to_s +
           '.igc').downcase
  end

  def has_igc_file?
    return File.readable?(self.igc_file_path)
  end

  def track
    return @track if @track

    # Trigger reading of igc file
    igc_file

    @track
  end

  def igc_file
    return @igc_file if @igc_file

    @track = []

    begin
      @igc_file = IgcFile.open(self.igc_file_path)
    rescue Errno::ENOENT
      nil
    else
      @igc_file.read_contents
      @track = @igc_file.track
      @igc_file
    end
  end

  def update_from_igcfile(igc_file, original_filename = nil)

    if igc_file.pilot_name
      self.pilot = Flarc::Pilot.where(
        'LOWER(first_name||last_name) = ? OR ' +
        'LOWER(last_name||first_name) = ?',
        igc_file.pilot_name.downcase.tr('^a-z',''),
        igc_file.pilot_name.downcase.tr('^a-z','')).first
    end

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

  def duration
    return self.landing_time - self.takeoff_time
  end

  def json_polyline(options = {})
    @json_polyline ||= self.track.decimate(0.003).collect { |x| [x.lat.round(5), x.lon.round(5)] }.to_json
  end
end

end
