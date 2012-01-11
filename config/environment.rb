# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Flarc::Application.initialize!

## Exta-ugly hack to prevent unloading
#require './app/models/pilot'
#require '../yggdra/plugins/core_models/app/models/ygg/core/person'
#require '../yggdra/plugins/core_models/app/models/ygg/core/identity'
#
#::Ygg::Core::Person.class_eval do
#  has_one :pilot,
#          :class_name => '::Pilot'
#
#  def merge(other)
#    other.last_name += ' (Deleted)'
#
##    other.identities.each { |x| x.person = self ; x.save! }
##    other.channels.each { |x| x.person = self ; x.save! }
##    other.contacts.each { |x| x.person = self ; x.save! }
##    other.agreements.each { |x| x.person = self ; x.save! }
##    other.agreements_as_signer.each { |x| x.person = self ; x.save! }
#
#    self.identities << other.identities
#    self.channels << other.channels
#    self.contacts << other.contacts
##    self.agreements << other.agreements
##    self.agreements_as_signer << other.agreements_as_signer
#
#    self.pilot.merge(other.pilot)
#
#    other.save!
#    save!
#  end
#end
#
#::Ygg::Core::Identity.class_eval do
#  def email_hash
#    str = fqdn.strip.downcase
#    "#{Zlib.crc32(str)}_#{Digest::MD5.hexdigest(str)}"
#  end
#end
