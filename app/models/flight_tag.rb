class FlightTag < Ygg::BasicModel
  belongs_to :tag,
             :class_name => 'Tag'

  belongs_to :flight,
             :class_name => 'Flight'

  validates_presence_of :tag, :flight

  serialize :data

  def eql?(other)
    return false if !other.kind_of?(self.class)
    return self.tag_id == other.tag_id && self.flight_id == other.flight_id
  end

  def hash
    return self.tag_id * (self.flight_id || 1)
  end
end
