module Flarc

class UserController < ApplicationController

  def show
    if !hel_session || !hel_session.authenticated?
      render :status => 403
      return
    end

    @current_championships = Championship.current
    @old_championships = auth_person.pilot.championships.order('valid_from ASC')
    @flights_excerpt = auth_person.pilot.flights.joins(:championships).where(:championships => { :symbol => :cid_2012 }).order('takeoff_time DESC').limit(11)
  end
end

end
