xml.instruct!
xml.gpx(
  :version => "1.0",
  :creator => "CSVVA",
  :xmlns => "http://www.topografix.com/GPX/1/0",
  'xsi:schemaLocation' => "http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd") {

  xml.trk {
    xml.name("Volo di #{@target.pilot.person.name}")
    xml.desc do |x|
      #FIXME Absolute url
      x << "Aliante: #{link_to(@target.plane.registration, plane_path(@target.plane, :only_path => false))}<br/>"
      x << "Decollo: #{l(@target.takeoff_time, :format => :compact)}<br/>"
      x << "Atterraggio: #{l(@target.landing_time, :format => :compact)}<br/>"
      x << "Durata: #{l(Time.at(@target.landing_time-@target.takeoff_time), :format => '%H:%M')}<br/>"
      if (!@target.passenger.nil?) then
        x << "Passeggero: #{@target.passenger.person.name}<br/>"
      elsif (!@target.passenger_name.nil?) then
        x << "Passeggero: #{@target.passenger_name}<br/>"
      end
    end

    xml.trkseg {
      @target.track.each do |point|

        xml.trkpt(:lat => point.lat.round(6), :lon => point.lon.round(6)) {
          xml.ele(point.gnss_alt)
          xml.time(point.logged_at.xmlschema)
        }
      end
    }
  }
}
