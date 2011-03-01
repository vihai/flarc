require 'pp'

class StaticController < ApplicationController

  def show
    render :action => 'static/' + params[:id]
  end
end
