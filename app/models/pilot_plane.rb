class PilotPlane < Ygg::BasicModel
  set_table_name 'pilot_planes'

  belongs_to :pilot,
             :class_name => 'Pilot'

  belongs_to :plane,
             :class_name => 'Plane'
end
