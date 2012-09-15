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

  def decimate(max_distance)
    prevpoint = nil
    newtrack = []

    each do |x|
      if !prevpoint || prevpoint.rough_distance(x) > max_distance
        newtrack << x
        prevpoint = x
      end
    end

    newtrack
  end
end
