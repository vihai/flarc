class ChampionshipsController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :history ]

  def index
#    expires_in 1.hour, :public => true

    @championships = Championship.find(:all)
  end

  def show
#    expires_in 1.hour, :public => true
    fresh_when :etag => @championship, :last_modified => @championship.updated_at.utc
  end

  def history
  end

  protected
  
  def find_object
    @championship = Championship.find(params[:id])
  end
end
