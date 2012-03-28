module Flarc

class ClubsController < RestController

  rest_controller_for Club

  def show
    @flights = @target.flights.order('takeoff_time DESC').joins(:championships).where(:championships => { :symbol => :cid_2012 })
    super
  end
end

end
