xml.instruct!
xml.gpx(
  :version => "1.0",
  :creator => "CSVVA",
  :xmlns => "http://www.topografix.com/GPX/1/0",
  'xsi:schemaLocation' => "http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd") {

  xml.trk {
    xml.name("Volo di #{@flight.pilot.person.name}")
    xml.desc do |x|
      #FIXME Absolute url
      x << "Aliante: #{link_to(@flight.plane.registration, plane_path(@flight.plane, :only_path => false))}<br/>"
      x << "Decollo: #{l(@flight.takeoff_time, :format => :compact)}<br/>"
      x << "Atterraggio: #{l(@flight.landing_time, :format => :compact)}<br/>"
      x << "Durata: #{l(Time.at(@flight.landing_time-@flight.takeoff_time), :format => '%H:%M')}<br/>"
      if (!@flight.passenger.nil?) then
        x << "Passeggero: #{@flight.passenger.person.name}<br/>"
      elsif (!@flight.passenger_name.nil?) then
        x << "Passeggero: #{@flight.passenger_name}<br/>"
      end
    end

    xml.trkseg {
      @flight.track.each do |point|

        xml.trkpt(:lat => point.lat.round(6), :lon => point.lon.round(6)) {
          xml.ele(point.gnss_alt)
          xml.time(point.logged_at.xmlschema)
        }
      end
    }
  }
}
