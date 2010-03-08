module Hel
  class HelModel < ActiveRecord::Base
  include UsesGuid
    self.abstract_class = true
  
  end
end
