module Hel

class GroupMember < HelModel
  belongs_to :identity
  belongs_to :group
end

end
