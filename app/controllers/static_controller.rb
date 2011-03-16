require 'pp'

class StaticController < ApplicationController

  def index
    redirect_to "/static/#{current_site.to_s}/"
  end

  def show
    render :action => "static/#{params[:path]}"
  end
end
