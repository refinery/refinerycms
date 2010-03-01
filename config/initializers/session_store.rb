# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_refinerycms_session',
  :secret => 'e3e2d02f22c53782ef1e22d69296c9348f9aa26020c5763da0293c12556cd4da5d35b7b5edc5acf70dc4e06886f4a694bc2a406c45716328948908d38a78d36f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
