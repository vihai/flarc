require 'pp'

class StaticController < ApplicationController

  def index
    redirect_to "/static/#{current_site.to_s}/"
  end

  def show
    begin
      render :action => "static/#{params[:path]}"
    rescue ActionView::MissingTemplate
      render :template => "public/404", :layout => false, :status => 404
    end
  end
end
