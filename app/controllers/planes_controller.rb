class PlanesController < RestController

  rest_controller_for Plane

  view :combo do
    empty!
    attribute(:id) { show! }
    attribute(:registration) { show! }
    attribute(:plane_type) do
      include!
      empty!
      attribute(:id) { show! }
      attribute(:configurations) { include! }
      attribute(:name) { show! }
    end
  end

  filter :combo, lambda { |r| apply_search_to_relation(r, [ 'registration' ]) }

  def stats_by_pilot
    find_target

    respond_to do |format|
      format.html
      format.svg {
        graph = Scruffy::Graph.new(:theme => CsvvaTheme.new)
        graph.title = "Voli per pilota"
        graph.renderer = Scruffy::Renderers::Pie.new

        stats = Hash[@target.flights.all(:select => "pilots.id,count(*) AS cnt",
                                    :joins => "JOIN pilots ON flights.pilot_id=pilots.id",
                                    :group => "pilots.id").map { |x|
                                      [ Pilot.find(x.id).person.name, x.cnt.to_i ] }]

        graph.add :pie, '', stats

        send_data(graph.render, :type => "image/svg+xml", :disposition =>"inline")
      }
    end
  end
end
