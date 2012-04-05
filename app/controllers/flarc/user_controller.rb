module Flarc

class UserController < ApplicationController

  def show
    if !hel_session || !hel_session.authenticated?
      redirect_to root_path
      return
    end

    @current_championships = Championship.current

    if auth_person.pilot
      @old_championships = auth_person.pilot.championships.order('valid_from ASC')
      @flights_excerpt = auth_person.pilot.flights.joins(:championships).where(:championships => { :symbol => :cid_2012 }).order('takeoff_time DESC').limit(11)
    else
      @old_championships = []
      @flights_excerpt = []
    end
  end
end

end
