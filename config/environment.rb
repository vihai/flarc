# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Flarc::Application.initialize!

# Exta-ugly hack to prevent unloading
require '../yggdra/plugins/core_models/app/models/ygg/core/person'
require '../yggdra/plugins/core_models/app/models/ygg/core/identity'

::Ygg::Core::Person.class_eval do
  has_one :pilot,
          :class_name => '::Pilot'
end

::Ygg::Core::Identity.class_eval do
  def email_hash
    str = fqdn.strip.downcase
    "#{Zlib.crc32(str)}_#{Digest::MD5.hexdigest(str)}"
  end
end
