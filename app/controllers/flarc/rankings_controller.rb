module Flarc
class RankingsController < ApplicationController

  before_filter :find_object, :only => [ :show, :update, :destroy, :history ]

  def index
#    expires_in 1.hour, :public => true

    @rankings = Ranking.where(:official => true).order('priority ASC, name ASC').all
    @rankings_unofficial = Ranking.where(:official => false).order('priority ASC, name ASC').all
  end

  def show
#    expires_in 1.hour, :public => true
    fresh_when :etag => @ranking, :last_modified => @ranking.updated_at.utc
  end

  def history
  end

  def regenerate
    Flarc::Ranking.compute_all

    respond_to do |format|
      format.json { render :json => {} }
    end
  end

  protected

  def find_object
    if (params[:id] =~ /^[0-9]+$/)
      @ranking = Ranking.find(params[:id])
    else
      @ranking = Ranking.find_by_sym(params[:id])
      raise ActiveRecord::RecordNotFound if !@ranking
    end
  end
end

end
