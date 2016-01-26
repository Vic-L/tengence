require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tengence
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # set sidekiq as queue adapter for active job
    config.active_job.queue_adapter = :sidekiq

    # NOTE!!! Timing in database is in UTC, but meant to read as SGT
    # set default config.time_zone as UTC, which is the default
    # config.time_zone = 
    # NOTE: use UTC (Time.current) to make queries when comparing to tender.closing_datetime
    # config.active_record.default_timezone = :utc
    # prevent conversion of time zone, although all alr UTC
    config.active_record.time_zone_aware_attributes = false

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/services/**/"]
    config.autoload_paths += Dir["#{config.root}/app/workers/**/"]
    config.autoload_paths += Dir["#{config.root}/app/models/**/"]

    # https
    config.force_ssl = (ENV['FORCE_HTTPS'] == 'true')
  end
end
