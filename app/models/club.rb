class Club < Ygg::PublicModel
  validates_presence_of :name

  has_many :pilots

  has_many :flights,
           :through => :pilots
end
