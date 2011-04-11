class PlanesController < RestController

  rest_controller_for Plane

  view :combo do
    empty!
    attribute(:id) { show! }
    attribute(:registration) { show! }
  end

  filter :combo, lambda { |r| apply_search_to_relation(r, [ 'registration' ]) }

  def stats_pilot
    respond_to do |format|
      format.html
      format.svg {
        graph = Scruffy::Graph.new(:theme => CsvvaTheme.new)
        graph.title = "Voli per pilota"
        graph.renderer = Scruffy::Renderers::Pie.new

        stats = Hash[@plane.flights.all(:select => "pilots.id,count(*) AS cnt",
                                    :joins => "JOIN pilots ON flights.pilot_id=pilots.id",
                                    :group => "pilots.id").map { |x|
                                      [ Pilot.find(x.id).person.name, x.cnt.to_i ] }]

        graph.add :pie, '', stats

        send_data(graph.render, :type => "image/svg+xml", :disposition =>"inline")
      }
    end
  end

  def new
    @plane = Plane.new

    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html "edit_form_div" , :partial => "form", :object => @plane
          page.visual_effect :fade, "list_div", :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, "edit_form_div", :duration => 0.5, :queue => 'end'
        end
      }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html "plane_edit_form_div" , :partial => "form", :object => @plane
          page.visual_effect :fade, "plane_info_div", :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, "plane_edit_form_div", :duration => 0.5, :queue => 'end'
        end

      }
    end
  end

  def create
    @plane = Plane.new(params[:plane])

    respond_to do |format|
      if @plane.save
        format.html { redirect_to(@plane) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @plane.update_attributes(params[:plane])
        format.html { redirect_to(@plane) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy

    @plane.destroy

    respond_to do |format|
      format.html { redirect_to(planes_url) }
      format.js  {
        render :update do |page|
          page.redirect_to(planes_url)
        end
      }
    end
  end

  protected
  
  def find_object
    @plane = Plane.find(params[:id])
  end

end
