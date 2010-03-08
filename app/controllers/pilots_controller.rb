
class PilotsController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :edit, :stats_plane ]

  def index
    @pilots = Pilot.find(:all, :joins => :person,
                         :order => "last_name ASC, first_name ASC")

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def stats_plane
    respond_to do |format|
      format.html
      format.svg {
        graph = Scruffy::Graph.new(:theme => CsvvaTheme.new)
        graph.title = "Voli per aliante"
        graph.renderer = Scruffy::Renderers::Pie.new

        stats = Hash[@pilot.flights.all(:select => "planes.registration,count(*) AS cnt",
                                    :joins => "JOIN planes ON flights.plane_id=planes.id",
                                    :group => "planes.registration").map { |x| [ x.registration, x.cnt.to_i ] }]

        graph.add :pie, '', stats

        send_data(graph.render, :type => "image/svg+xml", :disposition =>"inline")
      }
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html "pilot_edit_form_div" , :partial => "form", :object => @pilot
          page.visual_effect :fade, "pilot_info_div", :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, "pilot_edit_form_div", :duration => 0.5, :queue => 'end'
        end

      }
      format.html {
        render :partial => "form", :object => @pilot
      }
    end
  end

  def add_plane
    render :update do |page|
      page.insert_html :bottom, 'planes_list' , "Pippo"
    end
  end

  def create
    @pilot = Pilot.new(params[:pilot])

    respond_to do |format|
      if @pilot.save
        format.html { redirect_to(@pilot) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update

    params[:pilot][:championships].collect! { |x| Championship.find(x) }

    respond_to do |format|
      if @pilot.update_attributes(params[:pilot])
        format.html { redirect_to(@pilot) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @pilot.destroy

    respond_to do |format|
      format.html { redirect_to(pilots_url) }
    end
  end

protected

  def find_object
    @pilot = Pilot.find(params[:id])
  end

end
