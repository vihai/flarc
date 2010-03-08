
#
# - this should become a mixin
#
# caveats: 
# AR#to_xml does not properly serialize the root node of a namespaced model
# see http://dev.rubyonrails.org/ticket/8305, we have added a simple workaround here
# but we are going to need a proper patch *later* for parsing
#

class RestInterfaceController < ApplicationController

  before_filter :check_validation_action, :only => [ :update, :create ]
  before_filter :find_target, :only => [ :show, :edit, :update, :destroy, :validate_update ]
  before_filter :find_targets, :only => [ :index ]
    
  
  cattr_accessor :target_model
  attr_accessor :target, :targets
  
  def self.set_target_model(model)
    @@target_model = model
  end
    
  def index
    respond_to do |format|
      format.html
      format.xml { render :xml => targets.to_xml(:root => target_model_root_to_xml)}
      format.json { render :json => targets.to_json}
      format.yaml { render :yaml => targets.to_yaml}
    end
  end
  
  # GET /target/1
  def show
    respond_to do |format|
      format.html 
      format.xml { render :xml => target.to_xml(:root => target_model_root_to_xml)} ## see above note
      format.json { render :json => target.to_json}
      format.yaml { render :yaml => target.to_yaml}
    end
  end
  
  # GET /target/new
  def new
    @target = target_model.new
    respond_to do | format |
      format.html
      format.xml { render :xml => @target.to_xml(:root => target_model_root_to_xml)} ## see above note
      format.json { render :json => @target.to_json}
      format.yaml { render :yaml => @target.to_yaml}
    end
  end
  
  
  # POST /targets
  def create    
    @target = target_model.new(params[target_model_to_underscore])
    respond_to do |format|
      #if params[:_only_validation] == true
      #  format.html
      #  format.xml { render :xml => @target.to_xml(:success => false) }        
      #  format.json { render :json => @target.to_json(:success => false) }
      #  format.yaml { render :yaml => @target.to_yaml(:success => false) }
      #end           

      if @target.save
        flash[:notice] = '#{target_model.to_s.underscore} was successfully created.'
        format.html { render :action => :edit }
          
        # 201 Created
        format.xml { head :status => :created }
        format.json { head :status => :created }
        format.yaml { head :status => :created }
      else        
        format.html { render :action => :new }
        # 406 Not acceptable
        format.xml { render :xml =>@target.errors.to_xml, :status => :not_acceptable }
        format.json { render :json =>@target.errors.to_json, :status => :not_acceptable }
        format.yaml { render :yaml =>@target.errors.to_json, :status => :not_acceptable }        
      end


    end
  end
  
  # GET /target/1/edit
  def edit
    # nodoc
  end  
  
  # PUT /target/1
  def update
    respond_to do |format|
      if @target.update_attributes(params[target_model_to_underscore])
        flash[:notice] = '#{target_model.to_s.underscore} was successfully updated.'
        format.html { redirect_to :action => :index }

        # 202 Accepted
        format.xml { head :status => :accepted }
        format.json { head :status => :accepted }
        format.yaml { head :status => :accepted }
      else
        format.html { render :action => :edit }
        # 406 Not acceptable
        format.xml { render :xml =>@target.errors.to_xml, :status => :not_acceptable }
        format.json { render :json =>@target.errors.to_json, :status => :not_acceptable }
        format.yaml { render :yaml =>@target.errors.to_json, :status => :not_acceptable }
      end
    end
  end
  

  # DELETE /target/1
  def destroy   
    @target.destroy

    respond_to do |format|
      flash[:notice] = '#{target_model.to_s.underscore} was successfully destroyed.'
      format.html { redirect_to :action => :index }
      # 200 - Ok
      format.xml  { head :status => :ok }
      format.json  { head :status => :ok }
      format.yaml  { head :status => :ok }
    end
  rescue
    respond_to do |format|
      format.html { redirect_to :action => :index }
      # 500 - internal server erro
      format.xml  { head :status => :internal_server_error }
      format.json  { head :status => :internal_server_error }
      format.yaml  { head :status => :internal_server_error }
    end
  end
  
  
  
  
  private
  
  def target_model_root_to_xml
     target_model.to_s.underscore.gsub(/\//, ':')
  end
  
  def target_model_to_underscore
      target_model.to_s.underscore.gsub(/\//, "_")
  end
  
  def find_target
    begin
      @target = target_model.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render :status => 404, :nothing => true
      false
    end
  end
  
  def find_targets
    @targets = target_model.find(:all) ## missing options
  end
  
  #
  # if the form contains a _only_validation field then RESTful request is considered a "dry-run" and gets routed to a different
  # action named validate_*
  #
  def check_validation_action
    if params.has_key?(:_only_validation) && (params[:_only_validation].to_sym == :true)
       action = 'validate_' + action_name
       # redirect to a different action
       self.action_name = action if(respond_to?(action))
    end
  end
end