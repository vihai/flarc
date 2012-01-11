class AlpthermHistoryEntry < Ygg::BasicModel
  set_table_name 'alptherm_history_entries'

  belongs_to :source, :class_name => "AlpthermSource"
end
