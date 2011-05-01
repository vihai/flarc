class Pilot < Ygg::PublicModel
  belongs_to :person,
             :class_name => 'Ygg::Core::Person'

  belongs_to :club

  has_many :pilot_planes
  has_many :planes, :through => :pilot_planes
  has_many :flights

  has_many :ranking_standings

  has_many :championship_pilots,
           :class_name => '::Championship::Pilot',
           :dependent => :destroy,
           :embedded => true
  accepts_nested_attributes_for :championship_pilots, :allow_destroy => true

  has_many :championships,
           :through => :championship_pilots,
           :uniq => true

  validates_presence_of :person
  validates_uniqueness_of :person_id
#  validates_presence_of :club

  def merge(other)
    flights << other.flights
    planes << other.planes
    championship_pilots << other.championship_pilots
    save!
  end
end

