module Flarc

class UserController < ApplicationController

  def show
    if !hel_session || !hel_session.authenticated?
      redirect_to root_path
      return
    end

    @current_championships = Championship.current

    if auth_pilot
      @old_championships = auth_pilot.championships.where('valid_to < ?', Time.now).order('valid_from DESC')
      @flights_excerpt = auth_pilot.flights.joins(:championships).where(:championships => { :sym => 'cid_2012' }).order('takeoff_time DESC').limit(11)
    else
      @old_championships = []
      @flights_excerpt = []
    end
  end
end

end
