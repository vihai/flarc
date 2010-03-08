class FlightPhoto < ActiveRecord::Base
  belongs_to :flight

  def flickr_url(size = 's')
   size_text = (size.nil? || size == '-') ? "" : ("_" + size)

   return "http://farm#{self.farm_id}.static.flickr.com/" +
           "#{self.server_id}/#{self.photo_id}_#{self.secret}#{size_text}.jpg"
  end

end
