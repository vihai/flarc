class Plane < Ygg::PublicModel
  belongs_to :plane_type,
             :class_name => 'PlaneType'

  has_many :flights,
           :class_name => 'Flight'

  validates_presence_of :registration
  validates_length_of :registration, :in => 6..10

  validates_presence_of :plane_type

  def configurations_attributes=(attributes)
     # Process the attributes hash
  end
end
