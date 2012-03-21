module Flarc

class Championship < Ygg::PublicModel
  self.table_name = :championships

  has_many :championship_pilots,
           :class_name => 'Flarc::Championship::Pilot'
  has_many :pilots, :through => :championship_pilots

  has_many :rankings

  has_many :championship_flights,
           :class_name => 'Flarc::Championship::Flight',
           :dependent => :destroy,
           :embedded => true

  has_many :flights, :through => :championship_flights

  def self.current
    self.where('now() BETWEEN valid_from AND valid_to')
  end
end

end
