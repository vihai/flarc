require 'pp'

class StaticController < ApplicationController

  def index
    redirect_to "/static/#{current_site.to_s}/"
  end

  def show
    begin
      render :action => "static/#{params[:path]}"
    rescue ActionView::MissingTemplate
      raise ActionController::UnknownAction
    end
  end
end
