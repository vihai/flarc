# coding: utf-8

require 'flickraw_vihai'

class FlightsController < RestController

  rest_controller_for Flight

  view :edit do
    attribute :pilot do
      include!
      attribute :person do
        include!
      end
    end

    attribute :plane do
      include!
      attribute :plane_type do
        include!
      end
    end
  end

  def flight_search_conditions
    conditions = {}

    if params[:year] then
      day_beg = Time.local(params[:year], params[:month], params[:day])

      if params[:day] then
         day_end = day_beg + 1.days
      elsif params[:month] then
         day_end = day_beg + 1.month
      else
         day_end = day_beg + 1.year
      end

      conditions[:takeoff_time] = day_beg...day_end
    end

    conditions
  end

  def find_targets
    @targets_relation = model.scoped.where(flight_search_conditions)
    super
  end

  def calendar
#    expires_in 1.hour, :public => true if EXPIRES

    find_targets
    @flights = @targets

    @dates = {}
    @flights.select('takeoff_time::date AS takeoff_time, count(*) AS cnt').
               group('takeoff_time::date').
               order('takeoff_time::date ASC').each do |x|
      @dates[x.takeoff_time.year] ||= {}
      @dates[x.takeoff_time.year][x.takeoff_time.month] ||= {}
      @dates[x.takeoff_time.year][x.takeoff_time.month][x.takeoff_time.day] = x
    end
  end

  def show
##    expires_in 1.hour, :private => @target.private if EXPIRES

    super do |format|
      format.igc { serve_igc_file(@target) }

      format.gpx {
        if !@target.has_igc_file?
          render :nothing => true, :status => 404
          return
        end
        render :layout => false
      }

      format.kml {
        if !@target.has_igc_file?
          render :nothing => true, :status => 404
          return
        end
        render :layout => false
      }
    end
  end

  def wizard
    if request.method == 'POST'
      @req = ActiveSupport::JSON.decode(request.body)
      @req.symbolize_keys!

      Ygg::Core::Transaction.new 'Flight submission' do
        fres = @req[:flight]
        fres.symbolize_keys!

        pres = @req[:plane]
        if pres
          pres.symbolize_keys!
          plane = Plane.create(:registration => pres[:registration],
                               :plane_type => PlaneType.find(pres[:plane_type_id]))
          fres[:plane_id] = plane.id
        end

        igc_tmp_file = IgcTmpFile.find(@req[:igc_tmp_file_id])

        igc_file = IgcFile.open(igc_tmp_file.filename, 'rb')
        igc_file.read_contents {}

        @flight = Flight.new
        @flight.update_from_igcfile(igc_file, igc_tmp_file.original_filename)
        @flight.attributes = {
          :pilot => Pilot.find(fres[:pilot_id]),
          :plane => Plane.find(fres[:plane_id]),
          :plane_type_configuration_id => fres[:plane_type_configuration_id],
          :private => false,
          :notes_public => fres[:notes_public]
        }

        # Override pilot if not an admin
        if !hel_session.authenticated_admin?
          @flight.pilot = auth_person.pilot
        end

        fres[:championship_flights].each do |cf|
          cf.symbolize_keys!

          case cf[:_type]
          when 'Championship::Flight::Cid2011'
            cp = @flight.pilot.championship_pilots.where(:championship_id => Championship.find_by_symbol(:cid_2011)).first
            if !cp.cid_category
              ranking = nil
            elsif cp.cid_category.to_sym == :prom
              ranking = :prom
            else
              ranking = cf[:cid_ranking].to_sym
            end

            @flight.championship_flights << (a=Championship::Flight::Cid2011.new(
              :championship => Championship.find_by_symbol(:cid_2011),
              :flight => @flight, # Workaround for validations
              :status => :pending,
              :cid_ranking => ranking,
              :distance => cf[:distance],
              :task_eval => cf[:task_eval].to_sym,
              :task_type => cf[:task_type].to_sym,
              ))

          when 'Championship::Flight::Csvva2011'
            @flight.championship_flights << Championship::Flight::Csvva2011.new(
              :championship => Championship.find_by_symbol(:csvva_2011),
              :flight => @flight, # Workaround for validations
              :status => :pending,
              :distance => cf[:distance],
              )
          end
        end

        if !@flight.valid?
          raise UnprocessableEntity.new('Dati invalidi',
                  :per_field_msgs => @flight.errors.inject({}) { |h, (k, v)| h[k] = v; h },
                  :retry_possible => false)
        end

        @flight.save!

        File.rename(igc_tmp_file.filename, @flight.igc_file_path)
        igc_tmp_file.destroy
      end

      respond_to do |format|
        format.json { render :json => { :id => @flight.id } }
      end
    end
  end

  def tag_photos
    if !authenticated? || auth_person.pilot != @flight.pilot
      render :text => 'You are not authorized to access this section', :status => 403
      return
    end

    @flickr = FlickRawVihai::Session.new(FLICKR_API_KEY, FLICKR_SHARED_KEY, session[:flickr_token])

    if @flickr.token.nil?
      frob = @flickr.auth.getFrob

      redirect_to @flickr.auth_url(
                   :frob => frob,
                   :perms => 'write',
                   :extra => request.request_uri)
      return
    end

    @shift = params[:shift].nil? ? 0 : params[:shift].to_i
    @min_taken = @flight.takeoff_time + @shift.minutes
    @max_taken = @flight.landing_time + @shift.minutes
    @range = 3.hours

    @photos = @flickr.photos.search(:auth_token => session[:flickr_token],
                              :user_id => 'me',
                              :min_taken_date => (@min_taken - @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :max_taken_date => (@max_taken + @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :sort => 'date-taken-asc',
                              :extras => 'date_taken')
  end

  def tag_photos_ajax
    if !authenticated? || auth_person.pilot != @flight.pilot
      render :text => 'You are not authorized to access this section', :status => 403
      return
    end

    @flickr = FlickRawVihai::Session.new(FLICKR_API_KEY, FLICKR_SHARED_KEY, session[:flickr_token])

    @shift = params[:shift].nil? ? 0 : params[:shift].to_i
    @min_taken = @flight.takeoff_time + @shift.minutes
    @max_taken = @flight.landing_time + @shift.minutes
    @range = 3.hours

    @photos = @flickr.photos.search(:auth_token => session[:flickr_token],
                              :user_id => 'me',
                              :min_taken_date => (@min_taken - @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :max_taken_date => (@max_taken + @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :sort => 'date-taken-asc',
                              :extras => 'date_taken')

    render :partial => 'tag_photos_ajax', :object => @photos
  end

  def do_tag_photos
    if !authenticated? || auth_person.pilot != @flight.pilot
      render :text => 'You are not authorized to access this section', :status => 403
      return
    end

    @messages = Array.new

    @messages << 'Apertura connessione a Flickr'

    @flickr = FlickRawVihai::Session.new(FLICKR_API_KEY, FLICKR_SHARED_KEY, session[:flickr_token])

    if @flickr.token.nil?
      raise Prot
    end

    @shift = params[:shift].nil? ? 0 : params[:shift].to_i
    @min_taken = @flight.takeoff_time + @shift.minutes
    @max_taken = @flight.landing_time + @shift.minutes
    @range = 3.hours

    @photos = @flickr.photos.search(:auth_token => session[:flickr_token],
                              :user_id => 'me',
                              :min_taken_date => (@min_taken - @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :max_taken_date => (@max_taken + @range).strftime('%Y-%m-%d %H:%M:%S'),
                              :extras => 'date_taken')

    FlightPhoto.transaction do
      @flight.photos.clear

      @photos.each do |photo|
        if params[:photo][photo.id]

#@flickr.set_debug($stderr)
          info = @flickr.photos.getInfo(:photo_id => photo.id)
#@flickr.set_debug(nil)
#
          @messages << "Trovate informazioni per la foto #{photo.id}"

          @shift = params[:shift].nil? ? 0 : params[:shift].to_i
          taken = Time.parse(info.dates.taken) + @shift.minutes

          if !info.respond_to?(:location) || !params[:overwrite_geotag].nil?
            @messages << 'La foto non contiene informazioni di geolocalizzazione'

            point = @flight.track_points.nearest(taken)

            @messages << "Foto trovata alle coordinate (#{point.lat}, #{point.lon})"

            @flickr.photos.geo.setLocation(
                       :photo_id => photo.id,
                       :lat => point.lat,
                       :lon => point.lon,
                       :accuracy => 16,
                       :context => 2)

            @messages << 'Geolocalizzazione effettuata su Flickr'
            @messages << ''

            info = @flickr.photos.getInfo(:photo_id => photo.id)
          end

          url = info.urls.select { |url| url.type == 'photopage' }.first.to_s

          lat = info.location.latitude
          lon = info.location.longitude

          @flight.photos << FlightPhoto.new(:farm_id => photo.farm, :server_id => photo.server,
                                            :photo_id => photo.id, :secret => photo.secret,
                                            :lat => lat, :lon => lon, :url => url,
                                            :caption => ('Scattata da sopra ' +
                                                            info.location.locality.to_s + ', ' +
                                                            info.location.region.to_s + ', ' +
                                                            info.location.country.to_s))

          @messages << "Foto #{photo.id} inserita con successo"
        end
      end
    end
  end

  protected

  def serve_igc_file(flight)
    if !flight.has_igc_file?
      render :nothing => true, :status => 404
      return
    end

    headers['Content-Description'] = 'Flight file in IGC format'
    headers['Last-Modified'] = File.mtime(flight.igc_file_path).httpdate
    send_file flight.igc_file_path,
          :filename => flight.igc_filename,
          :type => Mime::IGC,
          :disposition => 'inline'
  end
end

