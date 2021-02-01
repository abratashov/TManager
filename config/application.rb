require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
load 'app/middleware/catch_json_parse_errors.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TManager
  class Application < Rails::Application

    if defined?(Dotenv)
      dotenv_files = [
        Rails.root.join(".env.#{Rails.env}"),
        Rails.root.join(".env")
      ]
      Dotenv.load(*dotenv_files)
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.middleware.use CatchJsonParseErrors

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end

host = ENV['APP_DEFAULT_URL_OPTIONS_HOST']
Rails.application.default_url_options[:host] = ENV['domain_name'] || host

routes_host = ENV['APP_ROUTES_DEFAULT_URL_OPTIONS_HOST']
Rails.application.routes.default_url_options[:host] = ENV['domain_name'] || routes_host
