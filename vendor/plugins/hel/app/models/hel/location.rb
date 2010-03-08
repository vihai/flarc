module Hel

class Location < HelModel
  def to_s
    [address, city, country].join(", ")
  end
end

end
