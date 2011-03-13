require 'pp'

class StaticController < ApplicationController

  def index
    redirect_to "/static/#{LAYOUTS[request.host]}/"
  end

  def show
    render :action => "static/#{params[:path]}"
  end
end
