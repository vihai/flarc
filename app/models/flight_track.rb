class FlightTrack < Array
  def near_timestamp(timestamp)

    nearest_point = nil
    nearest_distance = nil

    self.each do |x|
      distance = (x.logged_at - timestamp).abs

      puts "D=#{distance} ND=#{nearest_distance}"

      if nearest_distance && distance > nearest_distance
        break
      else
        nearest_point = x
        nearest_distance = distance
      end
    end

    return nearest_point
  end
end
