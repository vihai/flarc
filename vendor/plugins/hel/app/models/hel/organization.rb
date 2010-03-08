module Hel

class Organization < HelModel
  belongs_to :city, :foreign_key => "ro_city_id"
  belongs_to :city, :foreign_key => "op_city_id"
  belongs_to :city, :foreign_key => "billing_city_id"

  has_many :contacts
  has_many :identities, :through => :contacts
end

end
