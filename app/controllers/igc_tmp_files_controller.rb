class IgcTmpFilesController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :edit ]

  def index
    @igc_tmp_files = IgcTmpFile.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @track = []
    @igc_file = IgcFile.open(@igc_tmp_file.filename, 'rb')

    prevpoint = nil
    @igc_file.read_contents
    @track = @igc_file.track.decimate(0.01)

#    @encoded_polyline = GMapPolylineEncoder.new(:dp_threshold => 0.001).encode(
#                                @track.collect { |x| [x.lat, x.lon] })[:points]

    respond_to do |format|
      format.html
      format.igc { serve }
    end
  end

  def new
    @flight = IgcTmpFile.new

    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html 'upload_div' ,
                            :partial => 'upload_form'
          page.visual_effect :fade, 'list_div',
                             :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, 'upload_div',
                             :duration => 0.5, :queue => 'end'
        end

      }
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js {
        render :update do |page|
          page.replace_html 'igc_tmp_file_edit_form_div' , :partial => 'form', :object => @igc_tmp_file
          page.visual_effect :fade, 'igc_tmp_file_info_div', :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, 'igc_tmp_file_edit_form_div', :duration => 0.5, :queue => 'end'
        end

      }
    end
  end

  def create
    @igc_tmp_file = IgcTmpFile.new(params[:igc_tmp_file])
    @igc_tmp_file.pilot = auth_person.pilot

    if params[:iframed]
      request.format = :js_iframed
    end

    respond_to do |format|
      if @igc_tmp_file.save
        format.html { redirect_to(new_flight_url(:igc_tmp_file_id => @igc_tmp_file.id)) }
        format.js_iframed {
          responds_to_parent do
            render :update do |page|
              page.redirect_to(new_flight_url(:igc_tmp_file_id => @igc_tmp_file.id))
            end
          end
        }
      else
        format.html { render :action => 'new' }
        format.js_iframed {
          responds_to_parent do
            render :update do |page|
              page.redirect_to(new_flight_url(:igc_tmp_file_id => @igc_tmp_file.id))
            end
          end
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @igc_tmp_file.update_attributes(params[:igc_tmp_file])
        format.html { redirect_to(@igc_tmp_file) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  def destroy

    @igc_tmp_file.destroy

    respond_to do |format|
      format.html { redirect_to(igc_tmp_files_url) }
      format.js  {
        render :update do |page|
          page.redirect_to(igc_tmp_files_url)
        end
      }
    end
  end

  protected
  
  def find_object
    @igc_tmp_file = IgcTmpFile.find(params[:id])
  end

  def serve
    headers['Content-Description'] = 'Flight file in IGC format'
    headers['Last-Modified'] = File.mtime(@igc_tmp_file.filename).httpdate
    send_file @igc_tmp_file.filename,
          :filename => @igc_tmp_file.original_filename,
          :type => Mime::IGC,
          :disposition => 'inline'
  end
end
