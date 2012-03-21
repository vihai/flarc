module Flarc

class PilotPlane < Ygg::BasicModel
  self.table_name  = :pilot_planes

  belongs_to :pilot,
             :class_name => 'Flarc::Pilot'

  belongs_to :plane,
             :class_name => 'Flarc::Plane'
end

end
