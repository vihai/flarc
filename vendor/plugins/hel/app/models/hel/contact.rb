module Hel

class Contact < HelModel
  belongs_to :identity
  belongs_to :organization
  belongs_to :contact_area
  belongs_to :contact_role
end

end
