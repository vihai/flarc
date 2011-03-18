# coding: utf-8

require 'flickraw_vihai'

class FlightsController < RestController

  rest_controller_for Flight

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










  def autocomplete_plane
    @items = Plane.where([ 'LOWER(registration) LIKE ?', '%' + params['flight']['plane'].downcase + '%' ]).
                   order('registration ASC').
                   limit(10)

    render :inline => "<%= auto_complete_result @items, 'registration' %>"
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
          render :template => "public/404", :layout => false, :status => 404
          return
        end
        render :layout => false
      }

      format.kml {
        if !@target.has_igc_file?
          render :template => "public/404", :layout => false, :status => 404
          return
        end
        render :layout => false
      }
    end
  end

  def wizard

    catch :done do
      if request.method == 'GET'
        @state = {}
        @state[:state] = :plane
        @state[:final] = false
        @state[:igc_tmp_file_id] = params[:igc_tmp_file_id]
  
        @igc_tmp_file = IgcTmpFile.find(params[:igc_tmp_file_id])
  
        @igc_file = IgcFile.open(@igc_tmp_file.filename, 'rb')
        @igc_file.read_contents
  
        if @igc_file.glider_id
          plane = Plane.find_by_registration(@igc_file.glider_id.strip.upcase)
          @state[:plane_id] = plane ? plane.id : nil
        end

## TODO CHECK flight duplicate
  
      else
        @state = ActiveSupport::JSON.decode(params[:state]).symbolize_keys!
        @state[:state] = @state[:state].to_sym
        @state[:final] = false
  
        case @state[:state]
        when :plane
  
          @state[:plane_id] = params[:plane_id]
          @state[:pilot_id] = params[:pilot_id]
  
          if @state[:plane_id] != ''
            plane = Plane.find(@state[:plane_id])
            @state[:plane_type_id] = plane.plane_type.id
  
            if plane.plane_type.configurations.empty?
              @state[:state] = :done
            else
              @state[:state] = :plane_configuration
            end
          else
            @state[:state] = :new_plane
          end
  
        when :new_plane
          if params[:plane_type_id].empty?
            flash.now[:error] = "È necessario selezionare il tipo di aliante"
            throw :done
          end
          @state[:plane_type_id] = params[:plane_type_id]

          if params[:plane_registration].empty?
            flash.now[:error] = "È necessario indicare le marche dell'aliante"
            throw :done
          end
          @state[:plane_registration] = params[:plane_registration]
  
          plane_type = PlaneType.find(@state[:plane_type_id])
  
          if plane_type.configurations.empty?
            @state[:state] = :done
          else
            @state[:state] = :plane_configuration
          end
  
        when :plane_configuration
          if params[:plane_configuration_id].empty?
            flash.now[:error] = "È necessario indicare la configurazione dell'aliante"
            throw :done
          end

          @state[:plane_configuration_id] = params[:plane_configuration_id]
        end

        if @state[:state] = :done
          Ygg::Core::Transaction.new 'Flight submission' do
            @flight = Flight.new
  
            igc_tmp_file = IgcTmpFile.find(@state[:igc_tmp_file_id])
  
            igc_file = IgcFile.open(igc_tmp_file.filename, 'rb')
            igc_file.read_contents {}
            @flight.update_from_igcfile(igc_file, igc_tmp_file.original_filename)
  
            if asgard_session.authenticated_admin?
              @flight.pilot = Pilot.find(@state[:pilot_id])
            else
              @flight.pilot = auth_person.pilot
            end
  
            if @state[:plane_id]
              @flight.plane = Plane.find(@state[:plane_id])
            else
              @flight.plane = Plane.new(:plane_registration => @state[:plane_registration],
                                        :plane_type => PlaneType.find(@state[:plane_type_id]))
            end
  
            if @state[:plane_type_configuration_id]
              @flight.plane_type_configuration = PlaneTypeConfiguration.find(@state[:plane_type_configuration_id])
            end
  
            @flight.private = false
  
            @flight.save!
  
            File.rename(igc_tmp_file.filename, @flight.igc_file_path)
            igc_tmp_file.destroy
          end
  
          if current_site == :cid
            redirect_to cid_flight_wizard_path(:flight_id => @flight.id)
            return
          elsif current_site == :csvva
            redirect_to csvva_flight_wizard_path(:flight_id => @flight.id)
            return
          else
          end
        end

      end
    end

    render :template => "flights/wizard/#{@state[:state]}"
  end

  def show_map
    render :update do |page|
    end
  end

  # GET /flights/1/edit
  def edit

    prepare_form_tags

    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html 'edit_div' ,
                            :partial => 'form', :object => @flight
          page.visual_effect :fade, 'info_div',
                             :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, 'edit_div',
                             :duration => 0.5, :queue => 'end'
        end

      }
      format.html
    end
  end

  # POST /flights
  def create
  end

  # PUT /flights/1
  def update
    params[:flight][:passenger] = Person.where([ "first_name || ' ' || COALESCE(middle_name || ' ','') || last_name ILIKE ?", params[:flight][:passenger_name] ] ).first
    params[:flight][:distance] = params[:flight][:distance].to_f * 1000.0;

    params[:flight][:flight_tags_attributes].each { |k,v|
       v[:_destroy] = v[:status].empty?
    }

    update_successful = @flight.update_attributes(params[:flight])

    if update_successful
      flash.now[:notice] = 'Flight was successfully updated.'

      if params[:publish_to_facebook]
        facebook_user.session.post 'facebook.stream.publish',
              :message => "#{facebook_user.name} ha fatto un volo di #{(@flight.distance/1000.0).round} km."
      end

      respond_to do |format|
        format.html { redirect_to(flight_url(@flight, :ignore_cache => rand(1000000))) }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
      end
    end
  end

  # DELETE /flights/1
  def destroy
    @flight.destroy

    respond_to do |format|
      format.html { redirect_to(flights_url) }
      format.js  {
        render :update do |page|
          page.redirect_to(flights_url)
        end
      }
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

  def prepare_form_tags
    @flight_tags = @flight.flight_tags |
                       Tag.joins(:depends_on_championship => :pilots).where('pilots.id' => @flight.pilot.id).all.
                       collect { |x| FlightTag.new(:flight => @flight, :tag => x, :status => nil) }
  end
end

