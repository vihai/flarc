# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_csvva_session',
  :secret => '8cdcc72bc5c14c14b7a602fcd9edce6bda0c0663153d935def5eb860252ec98e37f0e0ccf6c253cfca1ed6e171315ff82cfb5d55c10eb828ddfa96b99e2bd187'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
