class PlaneTypesController < RestController

  rest_controller_for PlaneType

  # GET /plane_types/new
  def new
    @plane_type = PlaneType.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /plane_types/1/edit
  def edit
    respond_to do |format|
      format.js {
        render :update do |page|
          page.replace_html "plane_type_edit_form_div" , :partial => "form", :object => @plane
          page.visual_effect :fade, "plane_type_info_div", :duration => 0.5, :queue => 'end'
          page.visual_effect :appear, "plane_type_edit_form_div", :duration => 0.5, :queue => 'end'
        end

      }
      format.html {
        render :partial => "form", :object => @plane
      }
    end
  end

  # POST /plane_types
  def create
    @plane_type = PlaneType.new(params[:plane_type])

    respond_to do |format|
      if @plane_type.save
        format.html { redirect_to(@plane_type) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /plane_types/1
  def update

    respond_to do |format|
      if @plane_type.update_attributes(params[:plane_type])
        format.html { redirect_to(@plane_type) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /plane_types/1
  def destroy
    @plane_type.destroy

    respond_to do |format|
      format.html { redirect_to(plane_types_url) }
    end
  end

  protected
  
  def find_object
    @plane_type = PlaneType.find(params[:id])
  end
end
