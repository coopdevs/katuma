Katuma::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # ActionMailer configuration
  # config.action_mailer.raise_delivery_errors = false

  strategies = [
    # from YAML config file mailer.yml:
    #
    # production:
    #     delivery_method: smtp
    #     address: smtp.myservice.com
    #     port: 567
    #     user_name: me
    #     password: my-passw0rD
    -> (config) do
      begin
        mailer_settings = Rails.application.config_for(:mailer)
      rescue RuntimeError # Could not load configuration. No such file - ROOT/config/mailer.yml
        false
      else
        delivery_method = mailer_settings.delete("delivery_method").to_sym
        config.delivery_method = delivery_method
        if mailer_settings.present? # anything left
          config.send("#{delivery_method}_settings=", mailer_settings)
        end
        true
      end
    end,
    # from ENV
    -> (config) do
      if ENV['SMTP_USERNAME'].present?
        config.delivery_method = :smtp
        config.smtp_settings = {
          address:              ENV['SMTP_ADDRESS'],
          port:                 ENV['SMTP_PORT'],
          domain:               ENV['SMTP_DOMAIN'],
          user_name:            ENV['SMTP_USERNAME'],
          password:             ENV['SMTP_PASSWORD'],
          authentication:       (ENV['SMTP_AUTHENTICATION'].presence || 'plain'),
          enable_starttls_auto: (ENV['SMTP_ENABLE_STARTTLS_AUTO'].present? || false)
        }
        true
      else
        false
      end
    end,
    # from URL in ENV: smtp://user:pass@address:578/?domain=domain&authentication=plain&enable_starttls_auto=false
    -> (config) do
      if ENV['MAILER_URL'].present?
        url = URI.parse(ENV['MAILER_URL'])
        delivery_method = url.scheme.to_sym
        config.delivery_method = delivery_method
        query = Rack::Utils.parse_query(url.query)
        mailer_settings = {
          user_name: url.user,
          password: url.password,
          address: url.host,
          port: url.port,
          domain: query['domain'],
          authentication: (query['authentication'].presence || 'plain'),
          enable_starttls_auto: (query['enable_starttls_auto'].present? || false),
        }
        config.send("#{delivery_method}_settings=", mailer_settings)
      else
        false
      end
    end
  ]
  
  strategies.detect do |strategy|
    strategy.call(config.action_mailer)
  end

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.eager_load = true
end
