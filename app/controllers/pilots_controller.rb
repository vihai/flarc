
class PilotsController < RestController

  rest_controller_for Pilot

  view :edit do
    attribute(:person) do
      include!
    end
  end

  view :combo do
    empty!
    attribute(:id) { show! }
    attribute(:person) do
      include!
      empty!
      attribute(:name) { show! }
    end
  end

  view :combo_nf do
    empty!
    attribute(:id) { show! }
    attribute(:person) do
      include!
      empty!
      attribute(:name) { show! }
    end
    attribute(:championship_pilots) do
       show!
       attribute(:championship) do
         include!
         empty!
         attribute(:name) { show! }
       end
       attribute(:cid_category) { show! }
    end
  end

  filter :combo, lambda { |r|
    apply_search_to_relation(r, [ 'person.first_name', 'person.last_name' ])
  }

  def combo
    ext_combo do |x|
      "#{x.person.first_name} #{x.person.last_name}"
    end
  end

  def stats_plane
    respond_to do |format|
    format.html
      format.svg {
        graph = Scruffy::Graph.new(:theme => CsvvaTheme.new)
        graph.title = 'Voli per aliante'
        graph.renderer = Scruffy::Renderers::Pie.new

        stats = Hash[@pilot.flights.all(:select => 'planes.registration,count(*) AS cnt',
                                    :joins => 'JOIN planes ON flights.plane_id=planes.id',
                                    :group => 'planes.registration').map { |x| [ x.registration, x.cnt.to_i ] }]

        graph.add :pie, '', stats

        send_data(graph.render, :type => 'image/svg+xml', :disposition =>'inline')
      }
    end
  end

end
