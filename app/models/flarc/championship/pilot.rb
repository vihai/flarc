module Flarc
class Championship

class Pilot < Ygg::BasicModel
  self.table_name = :championship_pilots
  self.inheritance_column = :sti_type

  belongs_to :pilot,
             :class_name => 'Flarc::Pilot'

  belongs_to :old_pilot,
             :class_name => 'Flarc::OldPilot'

  belongs_to :championship,
             :class_name => 'Flarc::Championship'

#  validates_presence_of :pilot, :championship
end

end
end
