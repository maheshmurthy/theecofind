# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_green_session',
  :secret      => 'ea93b9c4fb567f13d520d5f5c48f357aa77a13b8aaaa2ece1eab575b7e056e9f0d89f42262d68ecf1f663035578610310f53178e28b32e767412b74ed775a49e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
