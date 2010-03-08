class Plane < ActiveRecord::Base
  belongs_to :plane_type
  has_many :flights

  validates_presence_of :registration
  validates_length_of :registration, :in => 6..10

  validates_presence_of :plane_type

  def configurations_attributes=(attributes)
     # Process the attributes hash
  end
end
