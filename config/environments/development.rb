R3::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
end


EXPIRES=false

FLICKR_API_KEY = "54d361a1e6542e2c8047c23a926bda5f"
FLICKR_SHARED_KEY = "c10b52eb00197665"

LAYOUTS = {
  "csvva.orlandi.com" => "csvva",
  "cir.orlandi.com" => "cir",
  "cir.fivv.it" => "cir"
}

GOOGLE_MAPS_KEY = {
  "csvva.orlandi.com" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxSc2yIvQoNUWDuSwbldoVMAKYyAbxTszy7ZWfIeC7-Gq8AF07pCq9le4A",
  "cir.fivv.it" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxStT6R7z5BM687XreQduSirwLQwRhTGunUCZCE96hn81ADkhUx-tl266w"
}

