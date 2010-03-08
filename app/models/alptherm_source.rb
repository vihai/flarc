class AlpthermSource < ActiveRecord::Base
  has_many :entries, :class_name => "AlpthermHistoryEntry",
           :foreign_key => "source_id"
end
