require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MasaYelp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.eager_load_paths << Rails.root.join("lib")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Use Redis as the main Rails.cache store where REDIS_URL is defined.
    # https://github.com/redis-store/redis-rails
    config.cache_store = :redis_store if ENV["REDIS_URL"]

    # Use Rack::Attack for rate limiting, client whitelisting, etc.
    config.middleware.use Rack::Attack

    # Add Rack::Attack::RateLimit to include X-RateLimit headers in all responses.
    config.middleware.use Rack::Attack::RateLimit, throttle: ["req/ip"]

    # http://guides.rubyonrails.org/generators.html
    config.generators do |g|
      g.helper false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: true
    end
  end
end
