module Flarc
class Championship

class Flight < Ygg::BasicModel
  self.table_name = :championship_flights
  self.inheritance_column = :sti_type

  belongs_to :championship,
             :class_name => 'Flarc::Championship'

  belongs_to :flight,
             :class_name => 'Flarc::Flight'

  validates_presence_of :championship, :flight

  interface :rest do
    self.allow_polymorphic_creation = true

    attribute(:sti_type) { exclude! }

    attribute(:points) do
      self.type = :float
    end
  end

  def points
    nil
  end

end

end
end
