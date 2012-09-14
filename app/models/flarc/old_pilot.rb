module Flarc

# Exta-ugly hack to prevent unloading
#require './app/models/pilot'
#require 'core_models/app/models/ygg/core/person'
#require '../yggdra/plugins/core_models/app/models/ygg/core/identity'


class OldPilot < Ygg::PublicModel
  self.table_name = :pilots

#  self.inheritance_column = :sti_type

#  belongs_to :person,
#             :class_name => 'Ygg::Core::Person'

  belongs_to :club

  has_many :pilot_planes
  has_many :planes, :through => :pilot_planes
  has_many :flights

  has_many :ranking_standings

  has_many :championship_pilots,
           :class_name => 'Flarc::Championship::Pilot',
           :dependent => :destroy,
           :embedded => true

  has_many :championships,
           :through => :championship_pilots,
           :uniq => true

#  validates_presence_of :person
#  validates_uniqueness_of :person_id
#  validates_presence_of :club

  def merge(other)
    flights << other.flights
    planes << other.planes
    championship_pilots << other.championship_pilots
    save!
  end
end


end
