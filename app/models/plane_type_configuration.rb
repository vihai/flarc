class PlaneTypeConfiguration < Ygg::BasicModel
  belongs_to :plane_type
  belongs_to :glider_class

  validates_presence_of :handicap
end
