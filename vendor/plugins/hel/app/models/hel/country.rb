module Hel

  class Country < HelModel
    
    
    validates_presence_of :name, :a2, :a3, :num
    validates_uniqueness_of :name, :a2, :a3, :num
  end

end
