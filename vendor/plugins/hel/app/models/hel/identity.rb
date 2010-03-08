module Hel

class Identity < HelModel
#  acts_as_paranoid
  uses_guid

  belongs_to :person, :class_name => '::Hel::Person'
  
  has_many :credentials,
           :class_name => 'Credential',
           :dependent => :destroy

  has_many :contacts
  has_many :organizations, :through => :contacts

  has_many :groups, :through => :group_members
  
  before_validation :normalize_fqdn

  validates_presence_of :fqdn, :uuid
  validates_uniqueness_of :fqdn, :uuid

  validates_rfc2822_format_of :fqdn
 
  # allows to be initialized with the simple constructor new("id@string")
 
  def initialize(params = {})
    if(params.is_a?(String))
      super(:fqdn => params)
    else
      super
    end   
  end

  def normalize_fqdn
    self.fqdn.strip
  end
  
end

end
