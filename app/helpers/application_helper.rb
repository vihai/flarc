# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def fmt_points(pts)
    pts ? (number_with_delimiter(pts.round) + ' pts') : 'N/A'
  end

  def fmt_distance_in_km(dist)
    number_with_delimiter((dist / 1000.0).round) + ' km'
  end

  def fmt_handicap(handicap)
   handicap.nil? ? 'N/A' : sprintf('%.2f', handicap) 
  end

  def status_icon(status)
    case status
    when 'pending'
      return image_tag('flight_status_pending.png',
                       :alt => 'Pending')
    when 'invalid'
      return image_tag('flight_status_invalid.png',
                       :alt => 'Invalid')
    when 'approved'
      return image_tag('flight_status_approved.png',
                       :alt => 'Approved')
    end
  end

  def image_url(source)
    abs_path = image_path(source)

    unless abs_path =~ /\Ahttp/
      abs_path = "http://#{request.host_with_port}#{abs_path}"
    end
      abs_path
  end 

 def flickr_url(photo, size = 's')
   size_text = (size.nil? || size == '-') ? '' : ('_' + size)

   return "http://farm#{photo.farm}.static.flickr.com/#{photo.server}/#{photo.id}_#{photo.secret}#{size_text}.jpg"
 end
end
