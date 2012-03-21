module Flarc

class GliderClass < Ygg::PublicModel
  self.table_name = :glider_classes

  has_many :plane_type_configuration
end

end
