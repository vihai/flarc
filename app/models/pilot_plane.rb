class PilotPlane < Ygg::BasicModel
  belongs_to :pilot,
             :class_name => 'Pilot'

  belongs_to :plane,
             :class_name => 'Plane'
end
