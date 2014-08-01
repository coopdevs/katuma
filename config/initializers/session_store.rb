# Be sure to restart your server when you modify this file.

Katuma::Application.config.session_store :cookie_store, key: '_katuma_session', httponly: true

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Katuma::Application.config.session_store :active_record_store
