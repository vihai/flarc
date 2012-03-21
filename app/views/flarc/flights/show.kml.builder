xml.instruct!
xml.kml(:xmlns => "http://earth.google.com/kml/2.2") {
  
  xml.Document {
    xml.name("Volo di #{@target.pilot.person.name}")
    xml.description do |x|
      #FIXME ADD CDATA
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
    xml.open(1)
    xml.visible(1)

    xml.Style(:id => "flight_track") {
      xml.LineStyle {
        xml.color("7fff00ff")
        xml.width(4)
      }
    }

 

  if params[:logo].nil? || params[:logo] == 1
   xml.ScreenOverlay {
     xml.name("Campionato CSVVA")
     xml.visibility(1)
     xml.Icon {
       xml.href(image_url("logo_acao_maps.png"))
     }
     xml.overlayXY(:x => 0, :y => 0,
                   :xunits => "fraction",
                   :yunits => "fraction")
     xml.screenXY(:x => 0, :y => 0,
                  :xunits => "fraction",
                  :yunits => "fraction")
     xml.rotationXY(:x => 0, :y => 0,
                    :xunits => "fraction",
                    :yunits => "fraction")
     xml.size(:x => 0, :y => 0,
              :xunits => "fraction",
              :yunits => "fraction")
   }
  end

    xml.Placemark {
      xml.name("Traccia con altitudine GPS")
      xml.visibility(1)
      xml.styleUrl("#flight_track")
      xml.LineString {
        xml.tessellate(1)
        xml.altitudeMode("absolute")
        xml.coordinates do |x|
          @target.track.each do |point|
             x << "#{point.lon.round(6)},#{point.lat.round(6)},#{point.gnss_alt}\n"
          end
        end
      }
    }

    xml.Folder {
      xml.name("Fotografie")
      xml.visibility(1)
      xml.open(0)

      @target.photos.each do |photo|
        xml.Placemark {
          xml.visibility(1)
          xml.description {
            xml.cdata!("#{link_to image_tag(photo.flickr_url('-')), photo.flickr_url('b'), :rel => "lightbox[gallery]", :title => photo.caption, :rev => photo.url}")
          }
          xml.Style {
            xml.IconStyle {
              xml.Icon {
                xml.href("http://maps.google.com/mapfiles/kml/pal4/icon46.png")
              }
            }
          }
          xml.Point {
            xml.coordinates do |x|
              x << "#{photo.lon.round(6)},#{photo.lat.round(6)},0\n"
            end
          }
        }
      end
    }

    xml.Folder {
      xml.name("Alptherm")
      xml.visibility(1)
      xml.open(0)

      AlpthermSource.all.each do |source|
        entry = source.entries.first(:conditions => [ "taken_at::date = ?::date", @target.takeoff_time ])
        next if entry.nil?

        xml.Placemark {
          xml.visibility(1)
          xml.description {
            xml.cdata!("<pre style=\"font-size: 75%; background-color: #CCCCFF;\">#{entry.data}</pre>")
          }
          xml.Style {
            xml.IconStyle {
              xml.Icon {
                xml.href("http://maps.google.com/mapfiles/kml/pal4/icon30.png")
              }
            }
          }
          xml.Point {
            xml.coordinates("#{source.lon},#{source.lat},0")
          }
        }
      end
    }
  }
}
