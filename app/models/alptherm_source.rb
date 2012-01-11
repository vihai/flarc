class AlpthermSource < Ygg::PublicModel
  set_table_name 'alptherm_sources'

  has_many :entries, :class_name => "AlpthermHistoryEntry",
           :foreign_key => "source_id"
end
