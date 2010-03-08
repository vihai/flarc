class AlpthermHistoryEntry < ActiveRecord::Base
  belongs_to :source, :class_name => "AlpthermSource"
end
