module Flarc

class Club < Ygg::PublicModel
  self.table_name = :clubs

  validates_presence_of :name

  has_many :pilots

  has_many :flights,
           :through => :pilots
end

end
