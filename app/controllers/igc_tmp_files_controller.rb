class IgcTmpFilesController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :edit ]

  def index
    @igc_tmp_files = IgcTmpFile.all

    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
      format.igc { serve_igc_file }
    end
  end

  def create
    @igc_tmp_file = IgcTmpFile.new(:file => params[:file], :pilot => auth_person.pilot)

    IgcTmpFile.transaction do

    respond_to do |format|
      if @igc_tmp_file.save

        begin
          igcf = @igc_tmp_file.igc_file
          igcf.read_contents
        rescue IgcFile::InvalidFileFormat => e
          @msg = "File IGC non valido o corrotto: #{e.to_s}"
          render :template => 'igc_tmp_files/failed_ajax_upload', :layout => false
          return
        end

        if igcf.pilot_name
          sc = ActiveRecord::Base.send(:sanitize_sql_array,
                 ['similarity(LOWER(first_name || \' \' || last_name), ?) DESC',
                  igcf.pilot_name.downcase])

          person = Ygg::Core::Person.joins(:pilot).order(sc).limit(1).first
          @pilot = person.pilot
        end

        if igcf.glider_id
          sc = ActiveRecord::Base.send(:sanitize_sql_array,
                 [ 'similarity(registration, ?) DESC',
                   igcf.glider_id.strip.upcase ])

          plane = Plane.order(sc).limit(1).first
          @plane = plane
        end

        format.html { render :layout => false }
      else
        format.html {
          @msg = 'File IGC non valido'
          render :template => 'igc_tmp_files/failed_ajax_upload', :layout => false
        }
      end
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

  def serve_igc_file
    headers['Content-Description'] = 'Flight file in IGC format'
    headers['Last-Modified'] = File.mtime(@igc_tmp_file.filename).httpdate
    send_file @igc_tmp_file.filename,
          :filename => @igc_tmp_file.original_filename,
          :type => Mime::IGC,
          :disposition => 'inline'
  end
end
