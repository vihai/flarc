class GliderClass < Ygg::PublicModel
  set_table_name 'glider_classes'

  has_many :plane_type_configuration
end
