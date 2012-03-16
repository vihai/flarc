class Championship

class Pilot < Ygg::BasicModel
  self.table_name = :championship_pilots
  self.inheritance_column = :sti_type

  belongs_to :pilot,
             :class_name => '::Pilot'
  belongs_to :championship,
             :class_name => '::Championship'

  validates_presence_of :pilot, :championship
end

end
