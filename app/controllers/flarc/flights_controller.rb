module Flarc

class FlightsController < RestController

  rest_controller_for Flight

  view :index do
    empty!

    attribute(:id) { show! }
    attribute(:takeoff_time) { show! }
    attribute(:landing_time) { show! }
    attribute(:distance) { show! }

    attribute :pilot do
      empty!
      include!
      attribute :person do
        empty!
        include!
        attribute(:name) { include! }
      end
    end

    attribute :plane do
      include!
      empty!
      attribute(:registration) { show! }
      attribute :plane_type do
        include!
        empty!
        attribute(:name) { show! }
      end
    end
  end

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

  def apply_search_conditions
    conditions = {}

    if params[:year]
      day_beg = Time.local(params[:year], params[:month], params[:day])

      if params[:day]
         day_end = day_beg + 1.days
      elsif params[:month]
         day_end = day_beg + 1.month
      else
         day_end = day_beg + 1.year
      end

      conditions[:takeoff_time] = day_beg...day_end
    end

    @targets_relation = @targets_relation.where(conditions)

    if params[:cship]
      @targets_relation = @targets_relation.joins(:championships).where(:championships => { :symbol => params[:cship] })
    end
  end

  def find_targets
    @targets_relation ||= model.scoped
    apply_search_conditions
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

  def edit
    @target_json = @target.output(:rest, :format => :json, :view => rest_view)
  end

  def submit
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
          when 'Championship::Flight::Cid2012'
            cp = @flight.pilot.championship_pilots.where(:championship_id => Championship.find_by_symbol(:cid_2012)).first
            if !cp.cid_category
              ranking = nil
            elsif cp.cid_category.to_sym == :prom
              ranking = :prom
            else
              ranking = cf[:cid_ranking].to_sym
            end

            @flight.championship_flights << (a=Championship::Flight::Cid2012.new(
              :championship => Championship.find_by_symbol(:cid_2012),
              :flight => @flight, # Workaround for validations
              :status => :pending,
              :cid_ranking => ranking,
              :distance => cf[:distance],
              :task_eval => cf[:task_eval].to_sym,
              :task_type => cf[:task_type].to_sym,
              ))

          when 'Championship::Flight::Csvva2012'
            @flight.championship_flights << Championship::Flight::Csvva2012.new(
              :championship => Championship.find_by_symbol(:csvva_2012),
              :flight => @flight, # Workaround for validations
              :status => :pending,
              :distance => cf[:distance],
              )
          end
        end

        if !@flight.valid?
          raise ActiveRest::Exception::UnprocessableEntity.new('Dati invalidi',
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

  def submit_update
    if request.method == 'POST'
      @req = ActiveSupport::JSON.decode(request.body)
      @req.symbolize_keys!

      Ygg::Core::Transaction.new 'Flight update' do
        fres = @req[:flight]
        fres.symbolize_keys!

        pres = @req[:plane]
        if pres
          pres.symbolize_keys!
          plane = Plane.create(:registration => pres[:registration],
                               :plane_type => PlaneType.find(pres[:plane_type_id]))
          fres[:plane_id] = plane.id
        end

        @flight = Flight.find(fres[:id])
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
          cfr = @flight.championship_flights.find(cf[:id])

          case cf[:_type]
          when 'Championship::Flight::Cid2012'
            cp = @flight.pilot.championship_pilots.where(:championship_id => Championship.find_by_symbol(:cid_2012)).first
            if !cp.cid_category
              ranking = nil
            elsif cp.cid_category.to_sym == :prom
              ranking = :prom
            else
              ranking = cf[:cid_ranking].to_sym
            end

            cfr.attributes = {
              :status => :pending,
              :cid_ranking => ranking,
              :distance => cf[:distance],
              :task_eval => cf[:task_eval].to_sym,
              :task_type => cf[:task_type].to_sym,
            }

          when 'Championship::Flight::Csvva2012'
            cfr.attributes = {
              :status => :pending,
              :distance => cf[:distance],
            }
          end

          cfr.save!
        end

        if !@flight.valid?
          raise ActiveRest::Exception::UnprocessableEntity.new('Dati invalidi',
                  :per_field_msgs => @flight.errors.inject({}) { |h, (k, v)| h[k] = v; h },
                  :retry_possible => false)
        end

        @flight.save!
      end

      respond_to do |format|
        format.json { render :json => { :id => @flight.id } }
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

end
