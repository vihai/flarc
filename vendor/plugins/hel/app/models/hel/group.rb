module Hel

class Group < HelModel
  has_many :group_members
  has_many :identitis, :through => :group_members
end

end
