module Flarc

class AlpthermHistoryEntry < Ygg::BasicModel
  self.table_name = :alptherm_history_entries

  belongs_to :source, :class_name => 'Flarc::AlpthermSource'
end

end
