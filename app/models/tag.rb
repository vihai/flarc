class Tag < Ygg::PublicModel
  has_many :flight_tags
  has_many :flights, :through => :flight_tags

  belongs_to :group, :class_name => 'TagGroup'

  belongs_to :depends_on_championship, :class_name => 'Championship'
end
