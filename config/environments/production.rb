Flarc::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

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

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.fb_api_key = '83b6646aa51c340d9f3a9bb4b40e105b'
  config.fb_secret_key = 'abbbba5dccf459257fc90f5777cea9f0'

  config.middleware.use ExceptionNotifier,
    :email_prefix => "[Flarc] ",
    :sender_address => %{"Flarc" <daniele@orlandi.com>},
    :exception_recipients => %w{daniele@orlandi.com}

  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
      rescue LoadError
    end
  end
end


EXPIRES=false

FLICKR_API_KEY = "b18c48dcc7c1f8811a291d537551c585"
FLICKR_SHARED_KEY = "cf3bf707d062d898"

GOOGLE_MAPS_KEY = {
  "csvva.orlandi.com" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxSc2yIvQoNUWDuSwbldoVMAKYyAbxTszy7ZWfIeC7-Gq8AF07pCq9le4A",
  "cir.fivv.it" => "ABQIAAAAVJLfFXWBxmyHNCyIIApsnxStT6R7z5BM687XreQduSirwLQwRhTGunUCZCE96hn81ADkhUx-tl266w"
}

FLIGHTS_STORAGE_DIR = File.join(Rails.root, "data", Rails.env, "flights")
FLIGHTS_TMP_DIR = File.join(Rails.root, "data", Rails.env, "igc_tmp_files")
