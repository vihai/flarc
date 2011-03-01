# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Csvva::Application.initialize!

Csvva::Application.config.middleware.swap ActionDispatch::ShowExceptions, Ygg::Asgard::ExtjsShowExceptions, Csvva::Application.config.consider_all_requests_local
