class RankingsController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :history ]

  def index
#    expires_in 1.hour, :public => true

    @rankings = Ranking.find(:all, :conditions => "official",
                                          :order => "priority ASC, name ASC")
    @rankings_unofficial = Ranking.find(:all, :conditions => "NOT official",
                                          :order => "priority ASC, name ASC")
  end

  def show
#    expires_in 1.hour, :public => true
    fresh_when :etag => @ranking, :last_modified => @ranking.updated_at.utc
  end

  def history
  end

  protected
  
  def find_object
    if (params[:id] =~ /^[0-9]+$/)
      @ranking = Ranking.find(params[:id])
    else
      @ranking = Ranking.find_by_symbol(params[:id])
    end
  end
end
