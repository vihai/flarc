class Plane < Ygg::PublicModel
  set_table_name 'planes'

  belongs_to :plane_type,
             :class_name => 'PlaneType'

  has_many :flights,
           :class_name => 'Flight'

  validates_presence_of :registration
  validates_length_of :registration, :in => 6..10
  validates_format_of :registration, :with => /^([A-Z0-9]{1,2}-[A-Z0-9]+|N[0-9]+[A-Z][A-Z])$/

  validates_presence_of :plane_type

  def configurations_attributes=(attributes)
     # Process the attributes hash
  end
end
