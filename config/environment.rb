# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
R3::Application.initialize!

Hel::Person
::Pilot

class Hel::Person
  has_one :pilot, :class_name => "::Pilot"
end

