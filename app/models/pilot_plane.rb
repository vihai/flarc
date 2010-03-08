class PilotPlane < ActiveRecord::Base
  belongs_to :pilot
  belongs_to :plane
end
