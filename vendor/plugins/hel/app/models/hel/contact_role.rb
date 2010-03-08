module Hel

class ContactRole < ActiveRecord::Base
  has_many :contacts
end

end
