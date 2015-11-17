require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Logging
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

    class LoggingMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        L.init(env["action_dispatch.request_id"])
        @app.call(env)
      end
    end

    config.middleware.insert_before( Rails::Rack::Logger, LoggingMiddleware)

    config.log_formatter = proc do |severity, datetime, progname, msg|
      now = Time.zone.now.to_f
      "[#{severity}] [#{datetime}] [PID=#{Process.pid}] [REQD=#{L.req_delta(now)}] [LOCD=#{L.local_delta(now)}] [RID=#{L.rid}] #{msg}\n"
    end
  end
end

require 'l'
