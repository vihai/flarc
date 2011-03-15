class Pilot < Ygg::PublicModel
  belongs_to :person,
             :class_name => 'Ygg::Core::Person'

  belongs_to :club

  has_many :pilot_planes
  has_many :planes, :through => :pilot_planes
  has_many :flights

  has_many :ranking_standings

  has_many :championship_pilots
  accepts_nested_attributes_for :championship_pilots, :allow_destroy => true

  has_many :championships, :through => :championship_pilots, :uniq => true

  validates_presence_of :person
  validates_uniqueness_of :person_id
#  validates_presence_of :club

  def steal_from_other_pilot(unlucky)
    self.flights << unlucky.flights
    self.planes << unlucky.planes
    self.championship_pilots << unlucky.championship_pilots

    self.person.birth_date = unlucky.person.birth_date if !self.person.birth_date
    self.person.vat_number = unlucky.person.vat_number if !self.person.vat_number
    self.person.italian_fiscal_code = unlucky.person.italian_fiscal_code if !self.person.italian_fiscal_code
    self.person.home_location_id = unlucky.person.home_location_id if !self.person.home_location_id
    self.person.birth_location_id = unlucky.person.birth_location_id if !self.person.birth_location_id
    self.person.tmp_telefono = unlucky.person.tmp_telefono if !self.person.tmp_telefono
    self.person.tmp_cellulare = unlucky.person.tmp_cellulare if !self.person.tmp_cellulare

    self.person.identities << unlucky.person.identities

    self.person.save!
    self.save!
  end
end

