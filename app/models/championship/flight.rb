class Championship

class Flight < Ygg::BasicModel
  self.table_name = :championship_flights
  self.inheritance_column = :sti_type

  belongs_to :championship,
             :class_name => '::Championship'

  belongs_to :flight,
             :class_name => '::Flight'

  validates_presence_of :championship, :flight

  serialize :data
end

end
