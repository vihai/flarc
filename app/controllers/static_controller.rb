require 'pp'

class StaticController < ApplicationController

  def show
    expires_in 1.hour, :public => true

    #workaround for rails3
    if !params[:site]
      params[:site] = 'jump'
      params[:id] = 'home'
    end

    if params[:site] == 'jump'
      if request.host == 'cir.orlandi.com' ||
         request.host == 'cir.fivv.it'
        params[:site] = 'cir'
      else
        params[:site] = 'csvva'
      end
    end

    render :action => 'static/' + params[:site] + '/' + params[:id]
  end
end
