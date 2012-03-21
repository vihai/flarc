module Flarc

class AlpthermSource < Ygg::PublicModel
  self.table_name = :alptherm_sources

  has_many :entries, :class_name => 'Flarc::AlpthermHistoryEntry',
           :foreign_key => :source_id
end

end
