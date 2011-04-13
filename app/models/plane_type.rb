class PlaneType < Ygg::BasicModel
  has_many :planes

  has_many :configurations,
           :class_name => '::PlaneType::Configuration',
           :embedded => true
  accepts_nested_attributes_for :configurations

  validates_presence_of :manufacturer
  validates_presence_of :name
  validates_presence_of :seats
  validates_numericality_of :seats

  validates_presence_of :motor
  validates_numericality_of :motor

  validates_numericality_of :handicap, :allow_nil => true
  validates_numericality_of :club_handicap, :allow_nil => true

  class Configuration < Ygg::BasicModel
    belongs_to :plane_type
    belongs_to :glider_class

    validates_presence_of :handicap
    validates_numericality_of :handicap, :allow_nil => true
    validates_numericality_of :club_handicap, :allow_nil => true
  end
end
