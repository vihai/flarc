class IgcFile < File
  class InvalidFileFormat < StandardError
  end

  B_EXTENSIONS = {
#    'DAE' => { :attr => :displ_east, :conv => 'to_i' },
#    'DAN' => { :attr => :displ_north, :conv => 'to_i' },
    'ENL' => { :attr => :engine_noise, :conv => 'to_i' },
    'FXA' => { :attr => :accuracy, :conv => 'to_i' },
    'GSP' => { :attr => :ground_speed, :conv => 'to_i' },
    'HDM' => { :attr => :heading_mag, :conv => 'to_i' },
    'HDT' => { :attr => :heading_true, :conv => 'to_i' },
    'IAS' => { :attr => :ias, :conv => 'to_i' },
#    'LAD' => { :attr => , :conv => 'to_i' },
#    'LOD' => { :attr => , :conv => 'to_i' },
#    'RAI' => { :attr => , :conv => 'to_i' },
#    'REX' => { :attr => , :conv => 'to_i' },
    'RPM' => { :attr => :rpm, :conv => 'to_i' },
    'SIU' => { :attr => :sat_in_use, :conv => 'to_i' },
    'TAS' => { :attr => :tas, :conv => 'to_i' },
#    'TDS' => { :attr => , :conv => 'to_i' },
    'TEN' => { :attr => :total_energy_altitude, :conv => 'to_i' },
    'TRM' => { :attr => :track_mag, :conv => 'to_i' },
    'TRT' => { :attr => :track_true, :conv => 'to_i' },
    'VXA' => { :attr => :vert_accuracy, :conv => 'to_i' },
    'WDI' => { :attr => :wind_dir, :conv => 'to_i' },
    'WSP' => { :attr => :wind_speed, :conv => 'to_i' },
  }.freeze

  MONTH_IDS = [ '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C' ].freeze
  DAY_IDS =  [ '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C',
               'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
               'P', 'Q', 'R', 'S', 'T', 'U', 'V' ].freeze
  MANUF_IDS = {
    'GCS' => 'A',
    'CAM' => 'C',
    'DSX' => 'D',
    'EWA' => 'E',
    'FIL' => 'F',
    'FLA' => 'G',
    'SCH' => 'H',
    'ACT' => 'I',
    'LXN' => 'L',
    'IMI' => 'M',
    'NTE' => 'N',
    'PES' => 'P',
    'PRT' => 'R',
    'SDI' => 'S',
    'TRI' => 'T',
    'WES' => 'W',
    'XXX' => 'X',
    'ZAN' => 'Z' }.freeze

  attr_reader :id_from_logger
  attr_reader :date
  attr_reader :pilot_name
  attr_reader :pilot_role
  attr_reader :glider_type
  attr_reader :glider_id
  attr_reader :datum_id
  attr_reader :datum_name
  attr_reader :gps_type
  attr_reader :gps_manufacturer
  attr_reader :pressure_sensor_type
  attr_reader :pressure_sensor_source
  attr_reader :fr_manufacturer
  attr_reader :fr_model
  attr_reader :firmware
  attr_reader :hardware
  attr_reader :competition_id
  attr_reader :competition_class
  attr_reader :takeoff_time
  attr_reader :landing_time

  class FlightIDFromLogger
    attr_accessor :manufacturer, :unique_id, :extension

    def initialize(manufacturer, unique_id, extension = nil)
      @manufacturer = manufacturer
      @unique_id = unique_id
      @extension = extension
    end

    def to_s
      @manufacturer.to_s + @unique_id.to_s + @extension.to_s
    end
  end

  def self.open(name, mode = nil, opts = nil)
    opts ||= {}
    mode ||= 'r'
    super name, mode, { :external_encoding => Encoding::ISO_8859_15, :internal_encoding => Encoding::UTF_8 }.merge(opts)
  end

  def read_contents(options = {})
    sequence = 0
    prev1 = prev2 = prev3 = nil
    prev1_speed = prev2_speed = speed = nil
    takeoff_altitude = nil
    landing_altitude = nil

    @track = FlightTrack.new
    @b_ext = []

    self.rewind

    self.each_line do |line|
      line.chomp!

      case line[0..0]
      when ''
        # Ignore
      when 'A'
        # FR Manufacturer and identification
        @id_from_logger = FlightIDFromLogger.new(line[1..3], line[4..6], line[7..-1])

      when 'H'
        # File header
        src = char_to_source(line[1..1])

        case line[2..4]
        when 'DTE'
          # Log time
          @date = Date.civil(line[9..10].to_i + 2000, line[7..8].to_i, line[5..6].to_i)
          @date_source = char_to_source(line[1..1])

        when 'PLT'
          if line[5..-1] =~ /([A-Z]+):(.*)/
            @pilot_role = $1
            @pilot_name = $2
          else
            @pilot_role = nil
            @pilot_name = line[5..-1]
          end

          @pilot_source = src

        when 'GTY'
          @glider_type = line[16..-1]
          @glider_type_source = src

        when 'GID'
          @glider_id = line[14..-1]
          @glider_id_source = src

        when 'DTM'
          @datum_id = line[5..7]
          @datum_name = line[14..-1]
          @datum_source = src

        when 'GPS'
          @gps_type = line[9..-1]
          @gps_source = src

        when 'PRS'
          @pressure_sensor_type = line[20..-1]
          @pressure_sensor_source = src

        when 'FTY'
          if line[12..-1] =~ /(.*),(.*)/
            @fr_manufacturer = $1
            @fr_model = $2
          else
            @fr_manufacturer = nil
            @fr_model = line[13..-1]
          end

          @fr_source = src

        when 'RFW'
          @firmware = line[21..-1]
          @firmware_source = src

        when 'RHW'
          @hardware = line[21..-1]
          @hardware_source = src

        when 'CID'
          @competition_id = line[19..-1]
          @competition_id_source = src

        when 'CCL'
          @competition_class = line[22..-1]
          @competition_class_source = src
        end

      when 'I'
        break if options[:headers_only]

        # Fix extension list
        ext_count = line[1..2].to_i

        ext_count.times do |i|
          off = i * 7

          @b_ext << { :start => line[off+3..off+4].to_i,
                      :end => line[off+5..off+6].to_i,
                      :code => line[off+7..off+9] }
        end

      when 'J'
        # Extension list of data in each K record line
      when 'C'
        # Task
      when 'L'
        # Ignore comments
      when 'D'
        # Differential GPS
      when 'F'
        # Satellite constellation
      when 'B'
        # Fix

        break if options[:headers_only]

        s = line[1..-1]

	# Ignores invalid records sometimes output by buggy loggers:
	# B1225064628379N00845959EA0262202701053000
	# LLXNORIGIN1201134630665N00846263E
	# LLXNORIGIN0000004627787N00846870E
	# B-0546274627657N00847028EA0258402663053000
	# F122549072513020804102316
	# B-0546154627404N00847265EA0257102651053000
	next if s[0..0] == '-'

        newpoint = FlightTrackPoint.new
        newpoint.sequence = sequence
        newpoint.logged_at = Time.utc(@date.year, @date.month,
                                    @date.day, s[0..1].to_i, s[2..3].to_i,
                                    s[4..5].to_i)
        newpoint.lat = (s[6..7].to_i + s[8..12].to_i / 60000.0) *
                         (s[13..13] == 'N' ? 1 : -1 )
        newpoint.lon = (s[14..16].to_i + s[17..21].to_i / 60000.0) *
                         (s[22..22] == 'E' ? 1 : -1 )
        newpoint.validity = s[23..23]
        newpoint.press_alt = s[24..28].to_i
        newpoint.gnss_alt = s[29..33].to_i
        sequence += 1

        @b_ext.each do |ext|
          if (B_EXTENSIONS[ext[:code]].nil?)
            # Log missing record
            next
          end

          newpoint.ext[B_EXTENSIONS[ext[:code]][:attr]] = s[ext[:start]-2..ext[:end]-1].send(B_EXTENSIONS[ext[:code]][:conv])
        end

        @track << newpoint

        yield newpoint if block_given?

	# Ugly and raw takeoff/landing detection

        if (!prev1.nil?)
          distance = newpoint.distance(prev1)
          speed = distance / (newpoint.logged_at - prev1.logged_at)

#$stdout.puts "P T#{newpoint.logged_at} A#{newpoint.gnss_alt} D#{distance} T#{newpoint.logged_at - prev1.logged_at} S#{speed * 3.6}\n"
        end

        if (!prev3.nil? && !prev2.nil? && !prev1.nil?)
          if (speed > 0 && prev1_speed > 20 && prev2_speed > 20)
            if (takeoff_altitude.nil?)
              @takeoff_time = prev3.logged_at
              takeoff_altitude = prev3.gnss_alt
#puts "Takeoff T#{newpoint.logged_at} A#{prev3.gnss_alt}\n"
            end

            if (!landing_altitude.nil?)
              @landing_time = nil
              landing_altitude = nil
#puts "Oops, wrong landing T#{newpoint.logged_at} A#{prev3.gnss_alt}\n"
            end
          elsif (speed < 10 && prev1_speed < 10 && prev2_speed < 10 &&
                 !takeoff_altitude.nil? &&
                 landing_altitude.nil?)
            @landing_time = prev3.logged_at
            landing_altitude = prev3.gnss_alt
#puts "Landing T#{newpoint.logged_at} A#{prev3.gnss_alt}\n"
          end
        end

        prev3 = prev2
        prev2 = prev1
        prev2_speed = prev1_speed
        prev1 = newpoint
        prev1_speed = speed

        if (landing_altitude.nil?) then
            @landing_time = newpoint.logged_at
            landing_altitude = newpoint.gnss_alt
#puts "Landing T#{newpoint.logged_at} A#{prev3.gnss_alt}\n"
        end

#puts newpoint.inspect

      when 'E'
        # Pilot Event
      when 'K'
        # Extension data
      when 'G'
        # Security record
      when 'O'
        # OLC
      when '_'
        # Ignore
      else
        raise InvalidFileFormat.new("Unknown record #{line[0..0].inspect} at line #{self.lineno}")
      end
    end
  end

  def track
    return @track if @track
    read_contents
    @track
  end

protected

  def char_to_source(c)
    case c
    when 'F'
      return :fl_recorder
    when 'O'
      return :oo
    when 'P'
      return :pilot
    when 'S'
      return :unknown_s
    else
      warn "unknown character #{c} in source"
    end
  end
end

