module Flarc

class StaticController < ApplicationController

  def index
    redirect_to "/flarc/static/#{current_site.to_s}/"
  end

  def show
    begin
      render :action => params[:path]
    rescue ActionView::MissingTemplate
      raise ActionController::UnknownAction
    end
  end
end

end
