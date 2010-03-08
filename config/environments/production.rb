R3::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!
end

EXPIRES=false

FLICKR_API_KEY = "b18c48dcc7c1f8811a291d537551c585"
FLICKR_SHARED_KEY = "cf3bf707d062d898"

LAYOUTS = {
  "csvva.orlandi.com" => "csvva",
  "cir.orlandi.com" => "cir",
  "cir.fivv.it" => "cir"
}

GOOGLE_MAPS_KEY = {
  "csvva.orlandi.com" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxSc2yIvQoNUWDuSwbldoVMAKYyAbxTszy7ZWfIeC7-Gq8AF07pCq9le4A",
  "cir.fivv.it" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxStT6R7z5BM687XreQduSirwLQwRhTGunUCZCE96hn81ADkhUx-tl266w"
}

FLIGHTS_STORAGE_DIR = File.join(RAILS_ROOT, "data", RAILS_ENV, "flights")
FLIGHTS_TMP_DIR = File.join(RAILS_ROOT, "data", RAILS_ENV, "igc_tmp_files")
